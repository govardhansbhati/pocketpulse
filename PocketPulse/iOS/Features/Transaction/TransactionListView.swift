//
//  TransactionListView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//


import SwiftUI
import SwiftData

struct TransactionListView: View {
    @Query(sort: \TransactionModel.date, order: .reverse) private var transactions: [TransactionModel]
    var body: some View {
        List(transactions) { transaction in
            TransactionRow(transaction: transaction)
        }
        .navigationTitle("All Transactions")
    }
}
