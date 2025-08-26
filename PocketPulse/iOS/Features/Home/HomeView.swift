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
    @StateObject private var viewModel = HomeViewModel()
    
    @Environment(\.navigateHome) private var navigate
    @Environment(\.presentSheet) private var presentSheet
    
    @State private var showBalanceBreakdown = false
    @State private var transactionToDelete: TransactionModel?
    
    @Query private var accounts: [AccountModel]
    @Query private var cards: [CardModel]
    @Query(sort: \TransactionModel.date, order: .reverse) private var transactions: [TransactionModel]
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                balanceSection
                cardCarouselSection
                recentTransactionsSection
            }
            .padding(.vertical)
        }
        
        .onAppear(perform: updateViewModel)
        
        .onChange(of: accounts) { updateViewModel() }
        .onChange(of: cards) { updateViewModel() }
        .onChange(of: transactions) { updateViewModel() }
        
        .deletionAlert(
            for: $transactionToDelete,
            ofType: .transaction(title: transactionToDelete?.title ?? "")
        ) { item in
            // Provide the specific deletion logic here, calling the TransactionManager.
            TransactionManager.delete(transaction: item, in: context)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: { navigate?(.profile) }) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                    }
                    VStack(alignment: .leading) {
                        Text(viewModel.welcomeMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("User Name")
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
            presentSheet?(.balanceBreakdown(Array(accounts)))
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
        .padding(.horizontal)
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
        VStack(alignment: .leading) {
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
            .padding(.horizontal)

            if viewModel.recentTransactions.isEmpty {
                PlaceholderView(
                    imageName: "doc.text.magnifyingglass",
                    title: "No Transactions Yet",
                    subtitle: "Your recent income and expenses will appear here.",
                    buttonLabel: "Add a Transaction"
                ) {}
                    .padding(.horizontal)
            } else {
                List {
                    ForEach(viewModel.recentTransactions.prefix(10)) { transaction in
                        TransactionRow(transaction: transaction)
                            .swipeActions (edge: .trailing, allowsFullSwipe: true){
                                Button(role: .destructive) {
                                    // This will now correctly trigger the alert
                                    transactionToDelete = transaction
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
                // Give the list a fixed height to prevent it from taking over the screen
                .frame(height: CGFloat(viewModel.recentTransactions.prefix(10).count) * 80) // Adjust the height per row as needed
            }
        }
    }
    
    // A helper function to avoid repeating the update call.
    private func updateViewModel() {
        viewModel.update(
            accounts: accounts,
            cards: cards,
            transactions: transactions
        )
    }
}
