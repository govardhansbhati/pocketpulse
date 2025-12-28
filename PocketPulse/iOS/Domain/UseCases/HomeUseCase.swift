//
//  HomeUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import Foundation

struct HomeSummary {
    public let currentBalance: Double
    public let totalIncome: Double
    public let totalExpense: Double
    public let cards: [CardModel]
    public let recentTransactions: [TransactionModel]
    public let welcomeMessage: String
}

protocol HomeUseCaseProtocol {
    func loadHome() async throws -> HomeSummary
}

final class HomeUseCase: HomeUseCaseProtocol {
    private let accounts: AccountsServiceProtocol
    private let cards: CardsServiceProtocol
    private let transactions: TransactionsServiceProtocol
    
    init(accounts: AccountsServiceProtocol, cards: CardsServiceProtocol, transactions: TransactionsServiceProtocol) {
        self.accounts = accounts
        self.cards = cards
        self.transactions = transactions
    }
    
    func loadHome() async throws -> HomeSummary {
        async let a = accounts.fetchAccounts()
        async let c = cards.fetchCards()
        async let t = transactions.fetchTransactions()
        let (accounts, cards, transactions) = try await (a, c, t)
        
        let currentBalance = accounts.reduce(0) { $0 + $1.balance }
        let welcome = (!accounts.isEmpty || !transactions.isEmpty) ? "Welcome Back!" : "Welcome!"
        
        let calendar = Calendar.current
        let monthInterval = calendar.dateInterval(of: .month, for: Date())
        let monthly = transactions.filter { tx in
            if let interval = monthInterval { return interval.contains(tx.date) }
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
            welcomeMessage: welcome
        )
    }
}
