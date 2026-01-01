//
//  Wallet.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//
import SwiftUI
import SwiftData

enum WalletTab: String, CaseIterable, Identifiable {
    case cards = "Cards"
    case accounts = "Accounts"
    
    var id: String { self.rawValue }
}

// MARK: - Main Wallet View
/// The main view for the Wallet tab, displaying lists of cards and accounts.
struct WalletView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel: WalletViewModel
    
    /// An action to navigate to a detail view, injected from the parent navigation stack.
    @Environment(\.navigateWallet) private var navigate
    /// An action to present a sheet for adding or editing an item.
    @Environment(\.presentWalletSheet) private var presentSheet
    
    /// State to control the selected tab (Cards or Accounts).
    @State private var selectedTab: WalletTab = .accounts
    
    init(viewModel: WalletViewModel? = nil) {
        if let vm = viewModel {
            _viewModel = StateObject(wrappedValue: vm)
        } else {
             _viewModel = StateObject(wrappedValue: WalletViewModel(useCase: MockWalletUseCase()))
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom large title
            HStack {
                Text(AppStrings.Wallet.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, AppConstants.Layout.paddingSmall)

            // Segmented picker to switch between Cards and Accounts
            Picker(AppStrings.Wallet.chooseTab, selection: $selectedTab) {
                ForEach(WalletTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, AppConstants.Layout.paddingMedium)
            
            // Conditionally display the correct list based on the selected tab.
            if selectedTab == .cards {
                cardListView
            } else {
                accountListView
            }
        }
        .task {
            await viewModel.load()
        }
        // An alert that is shown when `deleteErrorAlert` is not nil.
        .alert(item: $viewModel.alertInfo) { alertInfo in
            Alert(title: Text(alertInfo.title), message: Text(alertInfo.message), dismissButton: alertInfo.primaryButton)
        }
        .refreshable {
            await viewModel.load()
        }
    }
    
    // MARK: - Subviews with Swipe Actions
    
    /// A view builder that creates the list of cards.
    @ViewBuilder
    private var cardListView: some View {
        VStack {
            HStack {
                Text(AppStrings.Wallet.yourCardsTitle)
                    .font(.headline)
                Spacer()
                Button(action: { presentSheet?(.addCard(nil)) }) { // Pass nil to indicate adding a new card
                    Label(AppStrings.Wallet.addCardButton, systemImage: AppAssets.Icons.plus)
                }
            }
            .padding(.horizontal, AppConstants.Layout.paddingMedium)
            .padding(.top, AppConstants.Layout.paddingMedium)
            
            if viewModel.cards.isEmpty {
                Spacer()
                PlaceholderView(
                    imageName: AppAssets.Icons.creditCardFill,
                    title: AppStrings.Wallet.noCardsTitle,
                    subtitle: AppStrings.Wallet.noCardsSubtitle,
                    buttonLabel: AppStrings.Wallet.addFirstCard
                ) {
                    presentSheet?(.addCard(nil))
                }
                .padding(.horizontal, AppConstants.Layout.paddingMedium)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.cards) { card in
                        Button(action: { navigate?(.cardDetail(card)) }) {
                            CardView(card: card)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteCard(card)
                            } label: {
                                Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                            }
                        }
                    }
                    .onMove(perform: viewModel.moveCard)
                }
                .listStyle(.plain)
            }
        }
    }
    
    /// A view builder that creates the list of accounts.
    @ViewBuilder
    private var accountListView: some View {
        VStack {
            HStack {
                Text(AppStrings.Wallet.yourAccountsTitle)
                    .font(.headline)
                Spacer()
                Button(action: { presentSheet?(.addAccount(nil)) }) { // Pass nil to indicate adding a new account
                    Label(AppStrings.Wallet.addAccountButton, systemImage: AppAssets.Icons.plus)
                }
            }
            .padding(.horizontal, AppConstants.Layout.paddingMedium)
            .padding(.top, AppConstants.Layout.paddingMedium)
            
            if viewModel.accounts.isEmpty {
                Spacer()
                PlaceholderView(
                    imageName: AppAssets.Icons.buildingColumnsFill,
                    title: AppStrings.Wallet.noAccountsTitle,
                    subtitle: AppStrings.Wallet.noAccountsSubtitle,
                    buttonLabel: AppStrings.Wallet.addFirstAccount
                ) {
                    presentSheet?(.addAccount(nil))
                }
                .padding(.horizontal, AppConstants.Layout.paddingMedium)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.accounts) { account in
                        Button(action: { navigate?(.accountDetail(account)) }) {
                            AccountRowView(account: account)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteAccount(account)
                            } label: {
                                Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                            }
                        }
                    }
                    .onMove(perform: viewModel.moveAccount)
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    WalletView()
        .modelContainer(for: [AccountModel.self, CardModel.self])
}
