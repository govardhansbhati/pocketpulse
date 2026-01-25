//
//  MockStaticsUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 02/08/25.
//

import Foundation
import SwiftUI

final class MockStaticsUseCase: StaticsUseCaseProtocol {
    func loadStats(filter: TimeFilter, startDate: Date?, endDate: Date?) async throws -> StaticsSummary {
        let transactions = MockData.transactions // Assuming MockData is available globally or imported
        
        let minDate = transactions.min(by: { $0.date < $1.date })?.date ?? Date()
        let maxDate = transactions.max(by: { $0.date < $1.date })?.date ?? Date()
        
        let dateFilteredTxns = transactions.filter { txn in
            switch filter {
            case .thisWeek, .thisMonth:
                return filter.contains(txn.date)
            case .custom:
                guard let start = startDate, let end = endDate else { return false }
                let endOfDay = Calendar.current.startOfDay(for: end).addingTimeInterval(24*60*60-1)
                return txn.date >= Calendar.current.startOfDay(for: start) && txn.date <= endOfDay
            }
        }
        
        let totalIncome = dateFilteredTxns.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let totalExpense = dateFilteredTxns.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        
        // Mock Graph Data (Simplified)
        let incomeGrouped = Dictionary(grouping: dateFilteredTxns.filter { $0.type == .income })
        { Calendar.current.startOfDay(for: $0.date) }
        let expenseGrouped = Dictionary(grouping: dateFilteredTxns.filter { $0.type == .expense })
        { Calendar.current.startOfDay(for: $0.date) }
        
        var combinedData: [DailyTotal] = []
        incomeGrouped.forEach { date, transactions in
            combinedData.append(DailyTotal(date: date,
                                           amount: transactions.reduce(0) { $0 + $1.amount },
                                           type: .income))
        }
        expenseGrouped.forEach { date, transactions in
            combinedData.append(DailyTotal(date: date,
                                           amount: transactions.reduce(0)
                                           { $0 + $1.amount },
                                           type: .expense))
        }
        let graphData = combinedData.sorted { $0.date < $1.date }
        
        // Mock Category Stats
        let expenseTxns = dateFilteredTxns.filter { $0.type == .expense }
        let categoryGrouped = Dictionary(grouping: expenseTxns, by: { $0.category })
        let categoryStats = categoryGrouped.map { key, txns in
            ExpenseCategoryStat(name: key.displayName, amount: txns.reduce(0) { $0 + $1.amount }, color: .random)
        }.sorted(by: { $0.amount > $1.amount })

        return StaticsSummary(
            totalIncome: totalIncome,
            totalExpense: totalExpense,
            graphData: graphData,
            filteredTransactions: dateFilteredTxns,
            categoryStats: categoryStats,
            minTransactionDate: minDate,
            maxTransactionDate: maxDate
        )
    }
}
