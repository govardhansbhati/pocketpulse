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
                Text("Wallet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            // Segmented picker to switch between Cards and Accounts
            Picker("Choose a tab", selection: $selectedTab) {
                ForEach(WalletTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
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
                Text("Your Cards")
                    .font(.headline)
                Spacer()
                Button(action: { presentSheet?(.addCard(nil)) }) { // Pass nil to indicate adding a new card
                    Label("Add Card", systemImage: "plus")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if viewModel.cards.isEmpty {
                Spacer()
                PlaceholderView(
                    imageName: "creditcard.fill",
                    title: "No Cards Added",
                    subtitle: "Add your credit and debit cards to see them here.",
                    buttonLabel: "Add Your First Card"
                ) {
                    presentSheet?(.addCard(nil))
                }
                .padding(.horizontal)
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
                                Label("Delete", systemImage: "trash")
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
                Text("Your Accounts")
                    .font(.headline)
                Spacer()
                Button(action: { presentSheet?(.addAccount(nil)) }) { // Pass nil to indicate adding a new account
                    Label("Add Account", systemImage: "plus")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if viewModel.accounts.isEmpty {
                Spacer()
                PlaceholderView(
                    imageName: "building.columns.fill",
                    title: "No Accounts Added",
                    subtitle: "Add your bank accounts and cash wallets to get started.",
                    buttonLabel: "Add Your First Account"
                ) {
                    presentSheet?(.addAccount(nil))
                }
                .padding(.horizontal)
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
                                Label("Delete", systemImage: "trash")
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
