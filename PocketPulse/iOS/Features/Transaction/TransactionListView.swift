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
    @Environment(\.modelContext) private var context
    @Query(sort: \TransactionModel.date, order: .reverse) private var transactions: [TransactionModel]
    
    @State private var transactionToDelete: TransactionModel?

    var body: some View {
        List(transactions) { transaction in
            TransactionRow(transaction: transaction)
                .swipeActions {
                    Button(role: .destructive) {
                        transactionToDelete = transaction
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
        }
        .listStyle(.plain)
        .navigationTitle("All Transactions")
        .deletionAlert(
            for: $transactionToDelete,
            ofType: .transaction(title: transactionToDelete?.title ?? "")
        ) { item in
            // Provide the specific deletion logic here, calling the TransactionManager.
            TransactionManager.delete(transaction: item, in: context)
        }
    }
}
