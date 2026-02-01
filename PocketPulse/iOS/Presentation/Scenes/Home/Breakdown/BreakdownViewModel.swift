//
//  BreakdownViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import Combine
import Foundation

@MainActor
class BreakdownViewModel: ObservableObject {
    @Published var accounts: [AccountModel] = []
    @Published var totalBalance: Double = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let walletUseCase: WalletUseCaseProtocol
    
    init(walletUseCase: WalletUseCaseProtocol, accounts: [AccountModel] = []) {
        self.walletUseCase = walletUseCase
        self.accounts = accounts
        calculateTotal()
        
        // If initial accounts are empty, we might want to load them
        if accounts.isEmpty {
            Task { await loadData() }
        }
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        do {
            let walletData = try await walletUseCase.loadData()
            self.accounts = walletData.accounts
            calculateTotal()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func calculateTotal() {
        totalBalance = accounts.reduce(0) { $0 + $1.balance }
    }
}
