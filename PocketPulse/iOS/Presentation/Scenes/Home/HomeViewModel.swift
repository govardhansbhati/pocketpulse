//
//  HomeViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 17/07/25.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var currentBalance: Double = 0
    @Published var totalIncome: Double = 0
    @Published var totalExpense: Double = 0
    @Published var budgetLimit: Double = 50000 // Mock/Default
    @Published var currentMonthlySpending: Double = 0
    @Published var cards: [CardModel] = []
    @Published var recentTransactions: [TransactionModel] = []
    @Published var welcomeMessage: String = AppStrings.Home.welcomeMessage
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let useCase: HomeUseCaseProtocol
    private let transactionUseCase: TransactionUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: HomeUseCaseProtocol,
         transactionUseCase: TransactionUseCaseProtocol,
         dataUpdateService: DataUpdateServiceProtocol) {
        self.useCase = useCase
        self.transactionUseCase = transactionUseCase
        self.dataUpdateService = dataUpdateService
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        // Subscribe to data updates
        dataUpdateService.transactionUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in Task { await self?.load() } }
            .store(in: &cancellables)
            
        dataUpdateService.walletUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in Task { await self?.load() } }
            .store(in: &cancellables)
            
        dataUpdateService.billUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in Task { await self?.load() } }
            .store(in: &cancellables)
    }
    
    func deleteTransaction(_ transaction: TransactionModel) async {
        do {
            try await transactionUseCase.delete(transaction: transaction)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let summary = try await useCase.loadHome()
            currentBalance = summary.currentBalance
            totalIncome = summary.totalIncome
            totalExpense = summary.totalExpense
            currentMonthlySpending = summary.totalExpense // simplified for now
            // budgetLimit could be fetched from settings in future
            cards = summary.cards
            recentTransactions = summary.recentTransactions
            welcomeMessage = summary.welcomeMessage
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func budgetUsagePercentage() -> Double {
        guard budgetLimit > 0 else { return 0 }
        return (currentMonthlySpending / budgetLimit) * 100
    }
    
    func calculateProgressBarWidth(totalWidth: Double) -> Double {
        guard budgetLimit > 0 else { return 0 }
        return min(totalWidth * (currentMonthlySpending / budgetLimit), totalWidth)
    }
    
    var budgetRemainingDisplayString: String {
        return AppStrings.Home.budgetRemaining + ": " + (budgetLimit - currentMonthlySpending)
            .formatted(.currency(code: AppConstants.Currency.isoCode))
    }
}
