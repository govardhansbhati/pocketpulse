//
//  MockHomeUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//


//
//  MockHomeUseCase.swift
//  PocketPulse
//

import Foundation

final class MockHomeUseCase: HomeUseCaseProtocol {
    func loadHome() async throws -> HomeSummary {
        let accounts = MockData.accounts
        let cards = MockData.cards
        let transactions = MockData.transactions

        let currentBalance = accounts.reduce(0) { $0 + $1.balance }

        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: Date())
        let monthly = transactions.filter { tx in
            if let i = interval { return i.contains(tx.date) }
            return false
        }

        let income = monthly.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let expense = monthly.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }

        return HomeSummary(
            currentBalance: currentBalance,
            totalIncome: income,
            totalExpense: expense,
            cards: cards,
            recentTransactions: transactions,
            welcomeMessage: (!accounts.isEmpty || !transactions.isEmpty) ? "Welcome Back!" : "Welcome!"
        )
    }
}