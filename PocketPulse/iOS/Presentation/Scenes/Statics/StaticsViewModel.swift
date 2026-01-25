//
//  StaticsViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//

import SwiftUI
import SwiftData
import Combine

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
    private let transactionUseCase: TransactionUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: StaticsUseCaseProtocol,
         transactionUseCase: TransactionUseCaseProtocol,
         dataUpdateService: DataUpdateServiceProtocol) {
        self.useCase = useCase
        self.transactionUseCase = transactionUseCase
        self.dataUpdateService = dataUpdateService
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        dataUpdateService.transactionUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in 
                Task { [weak self] in
                    guard let self = self else { return }
                    await self.load(filter: self.currentFilter,
                                    startDate: self.currentStartDate,
                                    endDate: self.currentEndDate)
                }
            }
            .store(in: &cancellables)
    }
    
    // State for filter
    private var currentFilter: TimeFilter = .thisWeek
    private var currentStartDate: Date?
    private var currentEndDate: Date?
    
    func deleteTransaction(_ transaction: TransactionModel) async {
        do {
            try await transactionUseCase.delete(transaction: transaction)
            await load(filter: currentFilter, startDate: currentStartDate, endDate: currentEndDate)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func load(filter: TimeFilter, startDate: Date? = nil, endDate: Date? = nil) async {
        self.currentFilter = filter
        self.currentStartDate = startDate
        self.currentEndDate = endDate
        
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
