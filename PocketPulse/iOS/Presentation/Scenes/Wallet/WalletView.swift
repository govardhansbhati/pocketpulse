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
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(AppStrings.Wallet.title)
                        .font(.system(size: AppConstants.Size.balanceFontSize, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.adaptiveText)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 60) // Keep for safe area visual balance or use GeometryReader
                .padding(.bottom, AppConstants.Layout.paddingLarge)
                
                // Segmented picker
                Picker(AppStrings.Wallet.chooseTab, selection: $selectedTab) {
                    ForEach(WalletTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, AppConstants.Layout.paddingLarge)
                
                // Scrollable Content
                ScrollView {
                    VStack(spacing: AppConstants.Layout.spacingLarge) {
                        if selectedTab == .cards {
                            cardListView
                        } else {
                            accountListView
                        }
                        
                        // Bottom spacer
                        Color.clear.frame(height: 100)
                    }
                    .padding(.top, 10)
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea(edges: .top)
        }
        .task {
            await viewModel.load()
        }
        .alert(item: $viewModel.alertInfo) { alertInfo in
            Alert(title: Text(alertInfo.title), message: Text(alertInfo.message), dismissButton: alertInfo.primaryButton)
        }
        .refreshable {
            await viewModel.load()
        }
        .onReceive(NotificationCenter.default.publisher(for: .walletDataChanged)) { _ in
            Task { @MainActor in
                await viewModel.load()
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var cardListView: some View {
        VStack(spacing: AppConstants.Layout.spacingStandard) {
            HStack {
                Text(AppStrings.Wallet.yourCardsTitle)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText)
                Spacer()
                Button(action: { presentSheet?(.addCard(nil)) }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: AppConstants.Size.iconLarge, height: AppConstants.Size.iconLarge)
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        Image(systemName: AppAssets.Icons.plus)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.adaptiveText)
                    }
                }
                .opacity(viewModel.cards.isEmpty ? 0 : 1) // Hide if empty
            }
            .padding(.horizontal)
            
            // Credit Utilization Card
            if viewModel.totalCreditLimit > 0 {
                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                    VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                        Text(AppStrings.Wallet.creditUtilizationTitle)
                            .font(.headline)
                            .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                        
                        HStack {
                            Text(String(format: AppStrings.Wallet.creditUsedPercentFormat, (viewModel.totalCreditUsed / viewModel.totalCreditLimit) * 100))
                                .font(.title3)
                                .bold()
                                .foregroundColor(AppTheme.adaptiveText)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(String(format: AppStrings.Wallet.creditLimitFormat, viewModel.totalCreditLimit.formatted(.currency(code: AppStrings.Wallet.currencyCode))))
                                    .font(.caption)
                                Text(String(format: AppStrings.Wallet.creditUsedFormat, viewModel.totalCreditUsed.formatted(.currency(code: AppStrings.Wallet.currencyCode))))
                                    .font(.caption)
                            }
                            .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                        }
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 8)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: min(CGFloat(viewModel.totalCreditUsed / viewModel.totalCreditLimit) * geometry.size.width, geometry.size.width), height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(AppConstants.Layout.paddingMedium)
                }
                .padding(.horizontal)
            }
            
            if viewModel.cards.isEmpty {
                PlaceholderView(
                    imageName: AppAssets.Icons.creditCardFill,
                    title: AppStrings.Wallet.noCardsTitle,
                    subtitle: AppStrings.Wallet.noCardsSubtitle,
                    buttonLabel: AppStrings.Wallet.addFirstCard
                ) {
                    presentSheet?(.addCard(nil))
                }
                .padding(.horizontal)
            } else {
                LazyVStack(spacing: AppConstants.Layout.spacingStandard) {
                    ForEach(viewModel.cards) { card in
                        Button(action: { navigate?(.cardDetail(card)) }) {
                            CardView(card: card)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .contextMenu {
                            Button(role: .destructive) {
                                viewModel.deleteCard(card)
                            } label: {
                                Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var accountListView: some View {
        VStack(spacing: AppConstants.Layout.spacingStandard) {
            HStack {
                Text(AppStrings.Wallet.yourAccountsTitle)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText)
                Spacer()
                Button(action: { presentSheet?(.addAccount(nil)) }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: AppConstants.Size.iconLarge, height: AppConstants.Size.iconLarge)
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        Image(systemName: AppAssets.Icons.plus)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.adaptiveText)
                    }
                }
                .opacity(viewModel.accounts.isEmpty ? 0 : 1) // Hide if empty
            }
            .padding(.horizontal)
            
            // Net Worth Card
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(AppStrings.Wallet.netWorthTitle)
                            .font(.subheadline)
                            .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                        Text(viewModel.netWorth.formatted(.currency(code: AppStrings.Wallet.currencyCode)))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.adaptiveText)
                    }
                    Spacer()
                    Image(systemName: AppAssets.Icons.chartPieFill)
                        .font(.largeTitle)
                        .foregroundColor(AppTheme.primaryColor.opacity(0.8))
                }
                .padding(AppConstants.Layout.paddingMedium)
            }
            .padding(.horizontal)
            
            if viewModel.accounts.isEmpty {
                PlaceholderView(
                    imageName: AppAssets.Icons.buildingColumnsFill,
                    title: AppStrings.Wallet.noAccountsTitle,
                    subtitle: AppStrings.Wallet.noAccountsSubtitle,
                    buttonLabel: AppStrings.Wallet.addFirstAccount
                ) {
                    presentSheet?(.addAccount(nil))
                }
                .padding(.horizontal)
            } else {
                LazyVStack(spacing: AppConstants.Layout.spacingMedium) {
                    ForEach(viewModel.accounts) { account in
                        Button(action: { navigate?(.accountDetail(account)) }) {
                            // Ensure AccountRowView is glass-ready (it typically has its own style, we'll verify)
                            AccountRowView(account: account)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .contextMenu {
                            Button(role: .destructive) {
                                viewModel.deleteAccount(account)
                            } label: {
                                Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WalletView()
        .modelContainer(for: [AccountModel.self, CardModel.self])
}
