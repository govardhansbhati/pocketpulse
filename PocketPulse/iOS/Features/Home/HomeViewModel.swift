//
//  HomeViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 17/07/25.
//

import Foundation
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentBalance: Double = 0
    @Published var totalIncome: Double = 0
    @Published var totalExpense: Double = 0
    @Published var cards: [CardModel] = []
    @Published var recentTransactions: [TransactionModel] = []
    @Published var welcomeMessage: String = "Welcome!"
    
    func update(accounts: [AccountModel], cards: [CardModel], transactions: [TransactionModel]) {
        self.currentBalance = accounts.reduce(0) { $0 + $1.balance }
        self.cards = cards
        self.recentTransactions = Array(transactions)
        
        if !accounts.isEmpty || !transactions.isEmpty {
            self.welcomeMessage = "Welcome Back!"
        } else {
            self.welcomeMessage = "Welcome!"
        }
        
        calculateMonthlySummary(transactions: transactions)
    }
    
    private func calculateMonthlySummary(transactions: [TransactionModel]) {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: Date()) else { return }
        let monthlyTransactions = transactions.filter { monthInterval.contains($0.date) }
        self.totalIncome = monthlyTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        self.totalExpense = monthlyTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
}

