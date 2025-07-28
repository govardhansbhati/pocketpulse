//
//  HomeViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 17/07/25.
//


import Foundation
import Foundation
import SwiftData

class HomeViewModel: ObservableObject {
    @Published var currentBalance: Double = 0
    @Published var totalIncome: Double = 0
    @Published var totalExpense: Double = 0
    @Published var cards: [CardModel] = []
    @Published var recentTransactions: [TransactionModel] = []

    // This single method is called to refresh all data for the view
    func fetchData(context: ModelContext) {
        // The order is important: fetch transactions first, then calculate
        fetchRecentTransactions(context: context)
        fetchCards(context: context)
        calculateSummary(context: context)
    }

    private func fetchCards(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<CardModel>()
            self.cards = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch cards: \(error)")
        }
    }

    private func fetchRecentTransactions(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<TransactionModel>(sortBy: [.init(\.date, order: .reverse)])
            self.recentTransactions = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch transactions: \(error)")
        }
    }

    // --- LOGIC UPDATED HERE ---
    private func calculateSummary(context: ModelContext) {
        do {
            // 1. Calculate Current Balance (This logic was already correct)
            // It sums the balance of every account you have, including "Cash".
            let accounts = try context.fetch(FetchDescriptor<AccountModel>())
            self.currentBalance = accounts.reduce(0) { $0 + $1.balance }

            // 2. Calculate This Month's Income & Expenses (Updated Logic)
            let calendar = Calendar.current
            let today = Date()
            
            // Get the start of the current month
            guard let monthInterval = calendar.dateInterval(of: .month, for: today) else {
                return
            }
            let startOfMonth = monthInterval.start

            // Filter transactions to only include those from this month
            let monthlyTransactions = recentTransactions.filter { $0.date >= startOfMonth }
            
            // Calculate income and expenses from the monthly transactions
            self.totalIncome = monthlyTransactions
                .filter { $0.type == .income }
                .reduce(0) { $0 + $1.amount }

            self.totalExpense = monthlyTransactions
                .filter { $0.type == .expense }
                .reduce(0) { $0 + $1.amount }

        } catch {
            print("Error calculating summary: \(error)")
            // Reset to 0 on error
            self.currentBalance = 0
            self.totalIncome = 0
            self.totalExpense = 0
        }
    }
}

