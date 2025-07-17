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

    

    func fetchData(context: ModelContext) {
        fetchCards(context: context)
        fetchRecentTransactions(context: context)
        calculateSummary(context: context)
    }

    private func fetchCards(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<CardModel>(sortBy: [.init(\.cardHolderName)])
            self.cards = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch cards: \(error)")
            self.cards = []
        }
    }

    private func fetchRecentTransactions(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<TransactionModel>(sortBy: [.init(\.date, order: .reverse)])
            self.recentTransactions = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch transactions: \(error)")
            self.recentTransactions = []
        }
    }

    private func calculateSummary(context: ModelContext) {
        do {
            let accounts = try context.fetch(FetchDescriptor<AccountModel>())
            self.currentBalance = accounts.reduce(into: 0) { $0 + $1.balance }

            let calendar = Calendar.current
            let today = Date()

            let todayTransactions = recentTransactions.filter {
                calendar.isDate($0.date, inSameDayAs: today)
            }

            self.totalIncome = todayTransactions.filter { $0.type == .income }
                .reduce(0) { $0 + $1.amount }

            self.totalExpense = todayTransactions.filter { $0.type == .expense }
                .reduce(0) { $0 + $1.amount }

        } catch {
            print("Error calculating summary: \(error)")
            self.totalIncome = 0
            self.totalExpense = 0
        }
    }
}
