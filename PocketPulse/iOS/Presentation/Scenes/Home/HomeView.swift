//
//  Home.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import SwiftData
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
            _viewModel = StateObject(wrappedValue: HomeViewModel(useCase: mockUseCase, transactionUseCase: transactionUseCase))
        }
    }
    
    // Environment actions for navigation, sheets, and the side menu
    @Environment(\.navigateHome) private var navigate
    @Environment(\.presentSheet) private var presentSheet
    @Environment(\.presentSideMenu) private var presentSideMenu
    
    @Environment(ProfileViewModel.self) private var profileViewModel
    
    @State private var transactionToDelete: TransactionModel?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            List {
                // Section 1: Balance Section
                Section {
                    balanceSection
                }
                .listRowInsets(EdgeInsets(top: AppConstants.Layout.paddingMedium, leading: AppConstants.Layout.paddingMedium, bottom: 0, trailing: AppConstants.Layout.paddingMedium))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                // Section 2: Card Carousel
                Section {
                    cardCarouselSection
                }
                .listRowInsets(EdgeInsets(top: AppConstants.Layout.paddingMedium, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                // Section 3: Recent Transactions
                recentTransactionsSection
                
                // An invisible section to add extra space at the bottom
                Section {
                    Color.clear.frame(height: AppConstants.Size.listRowHeight)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .task { await viewModel.load() }
        .deletionAlert(
            for: $transactionToDelete,
            ofType: .transaction(title: transactionToDelete?.title ?? "")
        ) { item in
            // Provide the specific deletion logic here, calling the TransactionManager.
            Task { await viewModel.deleteTransaction(item) }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    // This button now correctly triggers the side menu via an environment action.
                    Button(action: { presentSideMenu?() }) {
                        IconView(icon: AppAssets.Icons.personCircleFill, size: 28, color: .primary)
                    }
                    VStack(alignment: .leading) {
                        Text(viewModel.welcomeMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(profileViewModel.name)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { navigate?(.notification) }) {
                    IconView(icon: AppAssets.Icons.bellFill, size: 20, color: .primary)
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var balanceSection: some View {
        Button(action: {
            presentSheet?(.balanceBreakdown([]))
        }) {
            VStack(spacing: AppConstants.Layout.spacingMedium) {
                HStack {
                    Text(AppStrings.Home.currentBalance)
                        .font(.headline)
                        .foregroundColor(.gray)
                    IconView(icon: AppAssets.Icons.infoCircle, size: 14, color: .secondary)
                }
                
                Text(viewModel.currentBalance, format: .currency(code: AppConstants.Currency.isoCode))
                    .font(.system(size: AppConstants.Size.balanceFontSize, weight: .bold))
                
                HStack {
                    VStack {
                        Text(AppStrings.Home.incomeTitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(viewModel.totalIncome, format: .currency(code: AppConstants.Currency.isoCode))
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text(AppStrings.Home.expensesTitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(viewModel.totalExpense, format: .currency(code: AppConstants.Currency.isoCode))
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(AppConstants.Layout.paddingMedium)
            .background(
                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                    Color.clear
                }
            )
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var cardCarouselSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(AppStrings.Home.yourCards)
                    .font(.headline)
                Spacer()
                if viewModel.cards.count > 4 {
                    Button(AppStrings.Common.viewAll) {
                        navigate?(.allCards)
                    }
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
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppConstants.Layout.spacingMedium) {
                            ForEach(viewModel.cards.prefix(4)) { card in
                                CardView(card: card)
                                    .frame(width: geometry.size.width * AppConstants.Size.cardWidthRatio)
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.horizontal)
                    }
                    .scrollTargetBehavior(.viewAligned)
                }
                .frame(height: AppConstants.Size.cardCarouselHeight)
            }
        }
    }
    
    @ViewBuilder
    private var recentTransactionsSection: some View {
        Section(header:
            HStack {
                Text(AppStrings.Home.recentTransactions)
                    .font(.headline)
                Spacer()
                if viewModel.recentTransactions.count > 10 {
                    Button(AppStrings.Common.viewAll) {
                        navigate?(.transactionList)
                    }
                }
            }
        ) {
            if viewModel.recentTransactions.isEmpty {
                PlaceholderView(
                    imageName: AppAssets.Icons.docTextMagnifyingGlass,
                    title: AppStrings.Home.noTransactionsTitle,
                    subtitle: AppStrings.Home.noTransactionsSubtitle
                )
            } else {
                ForEach(viewModel.recentTransactions.prefix(10)) { transaction in
                    TransactionRow(transaction: transaction)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                transactionToDelete = transaction
                            } label: {
                                Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                            }
                        }
                }
            }
        }
        .listRowSeparator(.hidden)
    }
}

