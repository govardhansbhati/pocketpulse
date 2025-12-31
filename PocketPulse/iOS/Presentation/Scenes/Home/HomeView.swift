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
        List {
            // Section 1: Balance Section
            Section {
                balanceSection
            }
            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            // Section 2: Card Carousel
            Section {
                cardCarouselSection
            }
            .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            // Section 3: Recent Transactions
            recentTransactionsSection
            
            // An invisible section to add extra space at the bottom
            Section {
                Color.clear.frame(height: 40)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
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
                        Image(systemName: "person.circle.fill") 
                            .font(.title2)
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
                    Image(systemName: "bell.fill")
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var balanceSection: some View {
        Button(action: {
            presentSheet?(.balanceBreakdown([]))
        }) {
            VStack(spacing: 12) {
                HStack {
                    Text("Current Balance")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(viewModel.currentBalance, format: .currency(code: "INR"))
                    .font(.system(size: 34, weight: .bold))
                
                HStack {
                    VStack {
                        Text("This Month's Income")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(viewModel.totalIncome, format: .currency(code: "INR"))
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("This Month's Expenses")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(viewModel.totalExpense, format: .currency(code: "INR"))
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var cardCarouselSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Your Cards")
                    .font(.headline)
                Spacer()
                if viewModel.cards.count > 4 {
                    Button("View All") {
                        navigate?(.allCards)
                    }
                }
            }
            .padding(.horizontal)
            
            if viewModel.cards.isEmpty {
                PlaceholderView(
                    imageName: "creditcard.fill",
                    title: "No Cards Added",
                    subtitle: "Add your credit and debit cards to manage them easily.",
                    buttonLabel: "Add Your First Card"
                ) {
                    presentSheet?(.addCard(nil))
                }
                .padding(.horizontal)
            } else {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.cards.prefix(4)) { card in
                                CardView(card: card)
                                    .frame(width: geometry.size.width * 0.8)
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.horizontal)
                    }
                    .scrollTargetBehavior(.viewAligned)
                }
                .frame(height: 220)
            }
        }
    }
    
    @ViewBuilder
    private var recentTransactionsSection: some View {
        Section(header:
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                Spacer()
                if viewModel.recentTransactions.count > 10 {
                    Button("View All") {
                        navigate?(.transactionList)
                    }
                }
            }
        ) {
            if viewModel.recentTransactions.isEmpty {
                PlaceholderView(
                    imageName: "doc.text.magnifyingglass",
                    title: "No Transactions Yet",
                    subtitle: "Your recent income and expenses will appear here. Tap the ⊕ button to add your first transaction."
                )
            } else {
                ForEach(viewModel.recentTransactions.prefix(10)) { transaction in
                    TransactionRow(transaction: transaction)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                transactionToDelete = transaction
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listRowSeparator(.hidden)
    }
}

