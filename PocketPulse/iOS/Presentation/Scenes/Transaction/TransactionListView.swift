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
                        Label {
                            AppText.Body(text: AppStrings.Common.delete,
                                         color: .red)
                            // Optional custom styling if Label supports it, but Label title is usually string. 
                            // Reverting to standard Label for swipe actions as they expect Text or String
                            Text(AppStrings.Common.delete)
                        } icon: {
                            Image(systemName: AppAssets.Icons.trash)
                        }
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
