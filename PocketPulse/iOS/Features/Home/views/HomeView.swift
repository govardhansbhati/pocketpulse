//
//  Home.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    // The ViewModel now correctly fetches and calculates data
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                balanceSection
                cardCarousel
                recentTransactionsSection
            }
            .padding()
            // Refreshable now correctly re-fetches all data
            .refreshable {
                viewModel.fetchData(context: context)
            }
        }
        // .onAppear is the key to loading data when the view is first shown
        .onAppear {
            viewModel.fetchData(context: context)
        }
    }

    // MARK: - Subviews (No changes)
    private var headerSection: some View {
        HStack {
            Image(systemName: "person.circle")
                .font(.largeTitle)
            Text("Welcome!")
                .font(.title)
                .bold()
            Spacer()
        }
    }

    private var balanceSection: some View {
        VStack(spacing: 12) {
            Text("Current Balance")
                .font(.headline)
                .foregroundColor(.gray)
            // This will now correctly show the sum of all account balances
            Text(viewModel.currentBalance, format: .currency(code: "INR"))
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.primary)

            HStack {
                VStack {
                    Text("This Month's Income")
                        .font(.caption)
                        .foregroundColor(.gray)
                    // This will now correctly show the current month's income
                    Text(viewModel.totalIncome, format: .currency(code: "INR"))
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Text("This Month's Expenses")
                        .font(.caption)
                        .foregroundColor(.gray)
                    // This will now correctly show the current month's expenses
                    Text(viewModel.totalExpense, format: .currency(code: "INR"))
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
    }

    private var cardCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                }
            }
        }
    }

    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                Spacer()
                Button("View All") { /* Future action */ }
            }

            if viewModel.recentTransactions.isEmpty {
                 ContentUnavailableView("No Transactions", systemImage: "doc.text.magnifyingglass")
            } else {
                ForEach(viewModel.recentTransactions.prefix(5)) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
    }
}
