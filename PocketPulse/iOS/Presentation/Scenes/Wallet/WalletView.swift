//
//  Wallet.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftData
import SwiftUI

enum WalletTab: String, CaseIterable, Identifiable {
    case cards = "Cards"
    case accounts = "Accounts"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .cards: return AppStrings.Wallet.tabCards
        case .accounts: return AppStrings.Wallet.tabAccounts
        }
    }
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
             _viewModel = StateObject(wrappedValue: WalletViewModel(
                useCase: MockWalletUseCase(),
                dataUpdateService: DataUpdateService.shared
             ))
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    AppText.Header(text: AppStrings.Wallet.title)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, AppConstants.Layout.headerTopPadding)
                // Keep for safe area visual balance or use GeometryReader
                .padding(.bottom, AppConstants.Layout.paddingLarge)
                
                // Segmented picker
                Picker(AppStrings.Wallet.chooseTab, selection: $selectedTab) {
                    ForEach(WalletTab.allCases) { tab in
                        Text(tab.title).tag(tab)
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
                        Color.clear.frame(height: AppConstants.Layout.bottomSpacerHeight)
                        // Keep generous spacing for scroll
                    }
                    .padding(.top, AppConstants.Layout.paddingTen)
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea(edges: .top)
        }
        .task {
            await viewModel.load()
        }
        .alert(item: $viewModel.alertInfo) { alertInfo in
            Alert(title: Text(alertInfo.title),
                  message: Text(alertInfo.message),
                  dismissButton: alertInfo.primaryButton)
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
                AppText.Title(text: AppStrings.Wallet.yourCardsTitle)
                Spacer()
                Button(action: { presentSheet?(.addCard(nil)) }, label: {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: AppConstants.Size.iconLarge, height: AppConstants.Size.iconLarge)
                            .overlay(Circle().stroke(Color.white.opacity(AppConstants.Opacity.light),
                                                     lineWidth: AppConstants.Layout.borderWidth))
                        Image(systemName: AppAssets.Icons.plus)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.adaptiveText)
                    }
                })
                .opacity(viewModel.cards.isEmpty ? 0 : 1) // Hide if empty
            }
            .padding(.horizontal)
            
            // Credit Utilization Card
            if viewModel.totalCreditLimit > 0 {
                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                    VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                        Text(AppStrings.Wallet.creditUtilizationTitle)
                            .font(.headline)
                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.high))
                        
                        HStack {
                            Text(String(format: AppStrings.Wallet.creditUsedPercentFormat,
                                        (viewModel.totalCreditUsed / viewModel.totalCreditLimit) * 100))
                                .font(.title3)
                                .bold()
                                .foregroundColor(AppTheme.adaptiveText)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(String(format: AppStrings.Wallet.creditLimitFormat,
                                            viewModel.totalCreditLimit
                                    .formatted(.currency(code: AppStrings.Wallet.currencyCode))))
                                    .font(.caption)
                                Text(String(format: AppStrings.Wallet.creditUsedFormat,
                                            viewModel.totalCreditUsed
                                    .formatted(.currency(code: AppStrings.Wallet.currencyCode))))
                                    .font(.caption)
                            }
                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                        }
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(AppConstants.Opacity.faint))
                                    .frame(height: AppConstants.Size.progressBarHeight)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: min(CGFloat(viewModel.totalCreditUsed / viewModel.totalCreditLimit) * geometry.size.width,
                                                      geometry.size.width),
                                           height: AppConstants.Size.progressBarHeight)
                            }
                        }
                        .frame(height: AppConstants.Size.progressBarHeight)
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
                        Button(action: { navigate?(.cardDetail(card)) }, label: {
                            CardView(card: card)
                        })
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
                AppText.Title(text: AppStrings.Wallet.yourAccountsTitle)
                Spacer()
                Button(action: { presentSheet?(.addAccount(nil)) }, label: {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: AppConstants.Size.iconLarge, height: AppConstants.Size.iconLarge)
                            .overlay(Circle()
                                .stroke(Color.white.opacity(AppConstants.Opacity.light),
                                        lineWidth: AppConstants.Layout.borderWidth))
                        Image(systemName: AppAssets.Icons.plus)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.adaptiveText)
                    }
                })
                .opacity(viewModel.accounts.isEmpty ? 0 : 1) // Hide if empty
            }
            .padding(.horizontal)
            
            // Net Worth Card
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(AppStrings.Wallet.netWorthTitle)
                            .font(.subheadline)
                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                        Text(viewModel.netWorth.formatted(.currency(code: AppStrings.Wallet.currencyCode)))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.adaptiveText)
                    }
                    Spacer()
                    Image(systemName: AppAssets.Icons.chartPieFill)
                        .font(.largeTitle)
                        .foregroundColor(AppTheme.primaryColor.opacity(AppConstants.Opacity.high))
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
                        Button(action: { navigate?(.accountDetail(account)) }, label: {
                            // Ensure AccountRowView is glass-ready (it typically has its own style, we'll verify)
                            AccountRowView(account: account)
                        })
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
