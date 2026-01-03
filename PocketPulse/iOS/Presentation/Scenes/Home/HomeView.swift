//
//  Home.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import SwiftData
// MARK: - Main Home View
// MARK: - Main Home View
struct HomeView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel? = nil) {
        if let vm = viewModel {
            _viewModel = StateObject(wrappedValue: vm)
        } else {
            // Temporary default wiring: use mock use case to satisfy required init
            let mockUseCase = MockHomeUseCase()
            let transactionUseCase = MockTransactionUseCase()
            _viewModel = StateObject(wrappedValue: HomeViewModel(
                useCase: mockUseCase,
                transactionUseCase: transactionUseCase,
                dataUpdateService: DataUpdateService.shared
            ))
        }
    }
    
    // Environment actions
    @Environment(\.navigateHome) private var navigate
    @Environment(\.presentSheet) private var presentSheet
    @Environment(\.presentSideMenu) private var presentSideMenu
    
    @Environment(ProfileViewModel.self) private var profileViewModel
    
    @State private var transactionToDelete: TransactionModel?
    
    var body: some View {
        ZStack {
            // Global Animated Background
            BackgroundView()
            
            VStack(spacing: 0) {
                // MARK: - Custom Glass Header
                // Replaces standard navigation bar for a more integrated feel
                HStack {
                    // Profile Button
                    Button(action: { presentSideMenu?() }) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44) // TODO: Add specific constant if needed, or keep as standard button size
                                .overlay(
                                    Circle().stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            IconView(icon: AppAssets.Icons.personCircleFill, size: AppConstants.Dimension.ContentSize.iconSize, color: AppTheme.primaryColor)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: AppConstants.Layout.paddingTopNano) {
                        Text(viewModel.welcomeMessage)
                            .font(.system(size: 12, design: .rounded)) // Caption size
                            .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                        Text(profileViewModel.name)
                            .font(.system(size: 18, weight: .bold, design: .rounded)) // Headline size
                            .foregroundColor(AppTheme.adaptiveText)
                            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                    }
                    .padding(.leading, AppConstants.Layout.paddingSmall)
                    
                    Spacer()
                    
                    // Notification Button
                    Button(action: { navigate?(.notification) }) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle().stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            IconView(icon: AppAssets.Icons.bellFill, size: AppConstants.Size.iconSmall, color: AppTheme.adaptiveText)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, AppConstants.Layout.spacingSmall)
                // Add top padding to account for safe area since we will hide navigation bar
                .padding(.top, 50)  // Keep 50 as safe area approximation or use GeometryReader
                
                // MARK: - Scrollable Dashboard
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: AppConstants.Layout.spacingLarge) {
                        
                        // Balance Widget
                        balanceSection
                            .padding(.horizontal)
                        
                        // Card Carousel
                        cardCarouselSection
                        
                        // Quick Actions
                        quickActionsSection
                        
                        // Budget Progress
                        budgetCardSection
                            .padding(.horizontal)
                        
                        // Recent Transactions
                        recentTransactionsSection
                            .padding(.horizontal)
                        
                        // Bottom Spacer for TabBar
                        Color.clear.frame(height: 100)
                    }
                    .padding(.top, 10)
                }
            }
            .ignoresSafeArea(edges: .top) // Let custom header handle top safe area
        }
        .task { await viewModel.load() }
        .deletionAlert(
            for: $transactionToDelete,
            ofType: .transaction(title: transactionToDelete?.title ?? "")
        ) { item in
            Task { await viewModel.deleteTransaction(item) }
        }
        .toolbar(.hidden, for: .navigationBar) // Hide default nav bar
    }
    
    // MARK: - Subviews
    private var balanceSection: some View {
        Button(action: {
            presentSheet?(.balanceBreakdown)
        }) {
            ZStack {
                GlassCard(cornerRadius: 30) { // Keep distinctive radius for main card
                    VStack(alignment: .leading, spacing: 20) {
                        // Title Row
                        HStack {
                            Text(AppStrings.Home.currentBalance)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                            Spacer()
                            IconView(icon: AppAssets.Icons.infoCircle, size: 16, color: AppTheme.primaryColor)
                        }
                        
                        // Main Balance
                        Text(viewModel.currentBalance, format: .currency(code: AppConstants.Currency.isoCode))
                            .font(.system(size: AppConstants.Size.balanceFontSize, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppTheme.adaptiveText, AppTheme.adaptiveText.opacity(0.9)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // Income/Expense Indicators
                        HStack(spacing: 20) {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(AppTheme.income.opacity(0.2))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: AppAssets.Icons.arrowDown)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(AppTheme.income)
                                    )
                                VStack(alignment: .leading, spacing: AppConstants.Layout.paddingTopNano) {
                                    Text(AppStrings.Home.incomeTitle)
                                        .font(.caption2)
                                        .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                                    Text(viewModel.totalIncome, format: .currency(code: AppConstants.Currency.isoCode))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(AppTheme.adaptiveText)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Divider()
                                .frame(height: 30)
                                .overlay(Color.white.opacity(0.2))
                            
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(AppTheme.expense.opacity(0.2))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: AppAssets.Icons.arrowUp)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(AppTheme.expense)
                                    )
                                VStack(alignment: .leading, spacing: AppConstants.Layout.paddingTopNano) {
                                    Text(AppStrings.Home.expensesTitle)
                                        .font(.caption2)
                                        .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                                    Text(viewModel.totalExpense, format: .currency(code: AppConstants.Currency.isoCode))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(AppTheme.adaptiveText)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(AppConstants.Layout.paddingLarge)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var cardCarouselSection: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingStandard) {
            HStack {
                Text(AppStrings.Home.yourCards)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                Spacer()
                if viewModel.cards.count > 4 {
                    Button(AppStrings.Common.viewAll) {
                        navigate?(.allCards)
                    }
                    .font(.subheadline)
                    .foregroundColor(AppTheme.primaryColor)
                }
            }
            .padding(.horizontal)
            
            if viewModel.cards.isEmpty {
                PlaceholderView(
                    imageName: AppAssets.Icons.creditCardFill,
                    title: AppStrings.Home.noCardsTitle,
                    subtitle: AppStrings.Home.noCardsSubtitle,
                    buttonLabel: AppStrings.Home.addFirstCard
                ) {
                    presentSheet?(.addCard(nil))
                }
                .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppConstants.Layout.spacingMedium) {
                        // First item spacer
                        Color.clear.frame(width: 0)
                        
                        ForEach(viewModel.cards.prefix(4)) { card in
                            CardView(card: card)
                                .frame(width: 320) // Fixed width for consistent look
                                .scrollTransition(axis: .horizontal) { content, phase in
                                    content
                                        .rotation3DEffect(
                                            .degrees(phase.value * -10),
                                            axis: (x: 0, y: 1, z: 0)
                                        )
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
                                        .opacity(phase.isIdentity ? 1.0 : 0.8)
                                }
                        }
                        
                        // Add Card Button in Carousel
                        Button(action: {
                             presentSheet?(.addCard(nil))
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .frame(width: 60, height: 200)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                
                                Image(systemName: AppAssets.Icons.plus)
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .contentMargins(.horizontal, 20, for: .scrollContent)
            }
        }
    }
    
    @ViewBuilder
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingStandard) {
            HStack {
                Text(AppStrings.Home.recentTransactions)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                Spacer()
                if viewModel.recentTransactions.count > 10 {
                    Button(AppStrings.Common.viewAll) {
                        navigate?(.transactionList)
                    }
                    .font(.subheadline)
                    .foregroundColor(AppTheme.primaryColor)
                }
            }
            
            if viewModel.recentTransactions.isEmpty {
                PlaceholderView(
                     imageName: AppAssets.Icons.docTextMagnifyingGlass,
                     title: AppStrings.Home.noTransactionsTitle,
                     subtitle: AppStrings.Home.noTransactionsSubtitle
                 )
            } else {
                LazyVStack(spacing: AppConstants.Layout.spacingMedium) {
                    ForEach(viewModel.recentTransactions.prefix(10)) { transaction in
                        TransactionRow(transaction: transaction)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    transactionToDelete = transaction
                                } label: {
                                    Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                                }
                            }
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var quickActionsSection: some View {
       EmptyView() 
       // Removed as per user feedback: Redundant with primary FAB
    }
    
    @ViewBuilder
    private var budgetCardSection: some View {
        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(AppStrings.Home.budgetTitle)
                        .font(.headline)
                        .foregroundColor(AppTheme.adaptiveText)
                    Spacer()
                    Text("\(Int(viewModel.budgetLimit > 0 ? (viewModel.currentMonthlySpending / viewModel.budgetLimit) * 100 : 0))%")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.primaryColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.primaryColor.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: min(geometry.size.width * (viewModel.budgetLimit > 0 ? viewModel.currentMonthlySpending / viewModel.budgetLimit : 0), geometry.size.width), height: 8)
                    }
                }
                .frame(height: 8)
                
                HStack {
                    Text(viewModel.currentMonthlySpending, format: .currency(code: AppConstants.Currency.isoCode))
                        .font(.subheadline)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                    Spacer()
                    Text(AppStrings.Home.budgetRemaining + ": \((viewModel.budgetLimit - viewModel.currentMonthlySpending).formatted(.currency(code: AppConstants.Currency.isoCode)))")
                        .font(.caption)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                }
            }
            .padding(AppConstants.Layout.paddingMedium)
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(.plain)
    }
}

