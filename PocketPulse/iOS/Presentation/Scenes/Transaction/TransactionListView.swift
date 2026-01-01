//
//  TransactionListView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//


import SwiftUI
import SwiftData

// MARK: - Transaction List View
struct TransactionListView: View {
    @StateObject private var viewModel: TransactionListViewModel
    @State private var transactionToDelete: TransactionModel?

    init(viewModel: TransactionListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List(viewModel.transactions) { transaction in
            TransactionRow(transaction: transaction)
                .swipeActions {
                    Button(role: .destructive) {
                        transactionToDelete = transaction
                    } label: {
                        Label(AppStrings.Common.delete, systemImage: "trash")
                    }
                }
        }
        .listStyle(.plain)
        .navigationTitle(AppStrings.Transaction.listTitle)
        .task {
            await viewModel.loadTransactions()
        }
        .deletionAlert(
            for: $transactionToDelete,
            ofType: .transaction(title: transactionToDelete?.title ?? "")
        ) { item in
            Task {
                await viewModel.delete(transaction: item)
            }
        }
    }
}
