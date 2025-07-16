//
//  AnalyticsStatsViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 16/07/25.
//


// MARK: - AnalyticsStatsViewModel
import SwiftUI
import SwiftData

@MainActor
class AnalyticsStatsViewModel: ObservableObject {
    @Published var categoryStats: [ExpenseCategoryStat] = []
    @Published var accountStats: [AccountStat] = []

    func loadData(context: ModelContext) {
        do {
            let allTransactions = try context.fetch(FetchDescriptor<TransactionModel>())
            let expenseTxns = allTransactions.filter { $0.type == .expense }

            let grouped = Dictionary(grouping: expenseTxns, by: { $0.category })
            categoryStats = grouped.map { key, txns in
                ExpenseCategoryStat(name: key.rawValue.capitalized, amount: txns.reduce(0) { $0 + $1.amount }, color: .random)
            }

            let accounts = try context.fetch(FetchDescriptor<AccountModel>())
            accountStats = accounts.map {
                AccountStat(name: $0.name, amount: $0.balance, color: .random)
            }
        } catch {
            print("Error loading analytics stats: \(error)")
        }
    }
}
