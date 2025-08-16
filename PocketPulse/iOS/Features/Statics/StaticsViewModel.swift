//
//  StaticsViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//

import SwiftUI
import SwiftData

@MainActor
class StaticsViewModel: ObservableObject {
    // Published properties for the view
    @Published var totalIncome: Double = 0
    @Published var totalExpense: Double = 0
    @Published var graphData: [DailyTotal] = []
    @Published var filteredTransactions: [TransactionModel] = []
    @Published var categoryStats: [ExpenseCategoryStat] = []
    
    func loadData(context: ModelContext, filter: TimeFilter, startDate: Date, endDate: Date) {
        do {
            let allTransactions = try context.fetch(FetchDescriptor<TransactionModel>())
            
            // 1. Filter transactions based on the selected time range
            let dateFilteredTxns = allTransactions.filter { txn in
                switch filter {
                case .thisWeek, .thisMonth:
                    return filter.contains(txn.date)
                case .custom:
                    // Ensure the range is inclusive of the end date
                    let endOfDay = Calendar.current.startOfDay(for: endDate).addingTimeInterval(24*60*60-1)
                    return txn.date >= Calendar.current.startOfDay(for: startDate) && txn.date <= endOfDay
                }
            }
            self.filteredTransactions = dateFilteredTxns.sorted(by: { $0.date > $1.date })
            
            // 2. Calculate total income and expense for the period
            self.totalIncome = dateFilteredTxns.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
            self.totalExpense = dateFilteredTxns.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
            
            // 3. Aggregate data for the bar chart
            let incomeGrouped = Dictionary(grouping: dateFilteredTxns.filter { $0.type == .income }) { Calendar.current.startOfDay(for: $0.date) }
            let expenseGrouped = Dictionary(grouping: dateFilteredTxns.filter { $0.type == .expense }) { Calendar.current.startOfDay(for: $0.date) }
            
            var combinedData: [DailyTotal] = []
            incomeGrouped.forEach { date, transactions in
                combinedData.append(DailyTotal(date: date, amount: transactions.reduce(0) { $0 + $1.amount }, type: .income))
            }
            expenseGrouped.forEach { date, transactions in
                combinedData.append(DailyTotal(date: date, amount: transactions.reduce(0) { $0 + $1.amount }, type: .expense))
            }
            self.graphData = combinedData.sorted { $0.date < $1.date }
            
            // 4. Calculate spending by category for the pie chart
            let expenseTxns = dateFilteredTxns.filter { $0.type == .expense }
            let categoryGrouped = Dictionary(grouping: expenseTxns, by: { $0.category })
            self.categoryStats = categoryGrouped.map { key, txns in
                ExpenseCategoryStat(name: key.displayName, amount: txns.reduce(0) { $0 + $1.amount }, color: .random)
            }.sorted(by: { $0.amount > $1.amount })
            
        } catch {
            print("Failed to load statistics data: \(error)")
        }
    }
}
