//
//  TransactionStatsViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 16/07/25.
//


// MARK: - TransactionStatsViewModel
import SwiftUI
import SwiftData

@MainActor
class TransactionStatsViewModel: ObservableObject {
    @Published var incomeAmount: Double = 0
    @Published var expenseAmount: Double = 0
    @Published var incomeData: [GraphData] = []
    @Published var expenseData: [GraphData] = []
    @Published var filteredTransactions: [TransactionModel] = []

    var customStartDate: Date?
    var customEndDate: Date?

    func loadData(context: ModelContext, filter: TimeFilter) {
        do {
            let allTransactions = try context.fetch(FetchDescriptor<TransactionModel>())
            let filtered = allTransactions.filter { txn in
                switch filter {
                case .thisWeek, .thisMonth:
                    return filter.contains(txn.date)
                case .custom:
                    guard let start = customStartDate, let end = customEndDate else { return false }
                    return txn.date >= start && txn.date <= end
                }
            }

            filteredTransactions = filtered
            incomeData = aggregate(transactions: filtered.filter { $0.type == .income })
            expenseData = aggregate(transactions: filtered.filter { $0.type == .expense })

            incomeAmount = incomeData.reduce(0) { $0 + $1.amount }
            expenseAmount = expenseData.reduce(0) { $0 + $1.amount }
        } catch {
            print("Failed to load transactions: \(error)")
        }
    }

    private func aggregate(transactions: [TransactionModel]) -> [GraphData] {
        let grouped = Dictionary(grouping: transactions) { Calendar.current.startOfDay(for: $0.date) }
        return grouped.map { GraphData(date: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.date < $1.date }
    }
}
