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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                balanceSection
                cardCarouselSection
                recentTransactionsSection
            }
            .padding()
        }
        .refreshable {
            viewModel.fetchData(context: context)
        }
        .onAppear {
            viewModel.fetchData(context: context)
        }
        .toolbar {
            // Leading item: Profile icon and dynamic welcome message
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
                        Text("User Name") // Placeholder
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
            }
            // Trailing item: Notification button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { navigate?(.notification) }) {
                    Image(systemName: "bell.fill")
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var balanceSection: some View {
        VStack(spacing: 12) {
            Text("Current Balance")
                .font(.headline)
                .foregroundColor(.gray)
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
    
    @ViewBuilder
    private var cardCarouselSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Your Cards")
                    .font(.headline)
                Spacer()
                if !viewModel.cards.isEmpty {
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
                    presentSheet?(.addCard)
                }
                .padding(.horizontal)
            } else {
                // Use a GeometryReader to calculate a dynamic width for the cards
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.cards.prefix(4)) { card in
                                CardView(card: card)
                                // Set a specific width for the card inside the carousel
                                    .frame(width: geometry.size.width * 0.8)
                            }
                        }
                        // Add padding inside the scroll view and enable snapping
                        .scrollTargetLayout()
                        .padding(.horizontal)
                    }
                    .scrollTargetBehavior(.viewAligned)
                }
                .frame(height: 220) // Give the carousel a fixed height
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
                if !viewModel.recentTransactions.isEmpty {
                    Button("View All") {
                        navigate?(.transactionList) // Navigate to transaction list
                    }
                }
            }
            
            if viewModel.recentTransactions.isEmpty {
                PlaceholderView(
                    imageName: "doc.text.magnifyingglass",
                    title: "No Transactions Yet",
                    subtitle: "Your recent income and expenses will appear here.",
                    buttonLabel: "Add a Transaction"
                ) {
                    // This action is now handled by  center "+" button in TabV,
                    // so no action is needed here.
                }
            } else {
                ForEach(viewModel.recentTransactions.prefix(10)) { transaction in
                    TransactionRow(transaction: transaction) 
                }
            }
        }
    }
}
