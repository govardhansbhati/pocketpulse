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

    func fetchData(context: ModelContext) {
        do {
            let accounts = try context.fetch(FetchDescriptor<AccountModel>())
            self.currentBalance = accounts.reduce(0) { $0 + $1.balance }
            self.cards = try context.fetch(FetchDescriptor<CardModel>())
            
            let transactionDescriptor = FetchDescriptor<TransactionModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            let allTransactions = try context.fetch(transactionDescriptor)
            self.recentTransactions = allTransactions
            
            if !accounts.isEmpty || !allTransactions.isEmpty {
                self.welcomeMessage = "Welcome Back!"
            } else {
                self.welcomeMessage = "Welcome!"
            }
            
            calculateMonthlySummary(transactions: allTransactions)
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }

    private func calculateMonthlySummary(transactions: [TransactionModel]) {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: Date()) else { return }
        let monthlyTransactions = transactions.filter { monthInterval.contains($0.date) }
        self.totalIncome = monthlyTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        self.totalExpense = monthlyTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
}

