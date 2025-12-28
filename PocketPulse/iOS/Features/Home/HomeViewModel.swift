//
//  HomeViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 17/07/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var currentBalance: Double = 0
    @Published var totalIncome: Double = 0
    @Published var totalExpense: Double = 0
    @Published var cards: [CardModel] = []
    @Published var recentTransactions: [TransactionModel] = []
    @Published var welcomeMessage: String = "Welcome!"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let useCase: HomeUseCaseProtocol
    
    init(useCase: HomeUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let summary = try await useCase.loadHome()
            currentBalance = summary.currentBalance
            totalIncome = summary.totalIncome
            totalExpense = summary.totalExpense
            cards = summary.cards
            recentTransactions = summary.recentTransactions
            welcomeMessage = summary.welcomeMessage
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
