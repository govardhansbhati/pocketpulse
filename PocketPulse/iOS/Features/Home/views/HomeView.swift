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
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()

//    init() {
//        let dummyContext = try! ModelContainer(for: TransactionModel.self, CardModel.self, AccountModel.self).mainContext
//        _viewModel = StateObject(wrappedValue: HomeViewModel(context: dummyContext))
//    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                balanceSection
                cardCarousel
                recentTransactionsSection
            }
            .padding()
            .refreshable {
                viewModel.fetchData(context: context)
            }
        }
        .onAppear {
            viewModel.fetchData(context: context)
        }
    }

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
            Text(viewModel.currentBalance, format: .currency(code: "INR"))
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.primary)

            HStack {
                VStack {
                    Text("Income")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(viewModel.totalIncome, format: .currency(code: "INR"))
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Text("Expenses")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(viewModel.totalExpense, format: .currency(code: "INR"))
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
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
                Button("View All") {
                    // Future action
                }
            }

            ForEach(viewModel.recentTransactions.prefix(10)) { transaction in
                TransactionRow(transaction: transaction)
            }
        }
    }
}
