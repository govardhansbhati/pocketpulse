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
    
    @Published var minTransactionDate: Date = .now
    @Published var maxTransactionDate: Date = .now
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let useCase: StaticsUseCaseProtocol
    
    init(useCase: StaticsUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func load(filter: TimeFilter, startDate: Date? = nil, endDate: Date? = nil) async {
        isLoading = true
        errorMessage = nil
        do {
            let summary = try await useCase.loadStats(filter: filter, startDate: startDate, endDate: endDate)
            self.totalIncome = summary.totalIncome
            self.totalExpense = summary.totalExpense
            self.graphData = summary.graphData
            self.filteredTransactions = summary.filteredTransactions
            self.categoryStats = summary.categoryStats
            self.minTransactionDate = summary.minTransactionDate
            self.maxTransactionDate = summary.maxTransactionDate
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
