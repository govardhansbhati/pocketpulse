//
//  AddIncomeViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import Foundation
import SwiftUI
import SwiftData

@MainActor
class AddIncomeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var category: TransactionCategory = .salary // Default income category
    @Published var date: Date = .now
    @Published var selectedAccount: AccountModel?
    
    @Published var accounts: [AccountModel] = []
    
    private let transactionUseCase: TransactionUseCaseProtocol
    private let accountUseCase: AccountUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    
    init(transactionUseCase: TransactionUseCaseProtocol,
         accountUseCase: AccountUseCaseProtocol,
         dataUpdateService: DataUpdateServiceProtocol) {
        self.transactionUseCase = transactionUseCase
        self.accountUseCase = accountUseCase
        self.dataUpdateService = dataUpdateService
    }
    
    func fetchData() async {
        do {
            self.accounts = try await accountUseCase.fetchAccounts()
            if selectedAccount == nil {
                selectedAccount = accounts.first
            }
        } catch {
            print("Error fetching accounts: \(error)")
        }
    }

    func saveTransaction() async -> Result<Void, ValidationError> {
        guard !title.isEmpty else { return .failure(.missingTitle(field: "title")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        guard let account = selectedAccount else { return .failure(.missingAccount) }

        let newTransaction = TransactionModel(
            title: title,
            amount: amountValue,
            type: .income,
            category: category,
            date: date,
            linkedAccountID: account.id
        )
        
        // Add to balance for income
        account.balance += amountValue
        
        do {
            try await accountUseCase.update(account: account)
            try await transactionUseCase.add(transaction: newTransaction)
            
            // Notify via service
            dataUpdateService.notifyTransactionUpdated()
            
            return .success(())
        } catch {
             print("Error saving income: \(error)")
             return .failure(.custom(message: "Failed to save income"))
        }
    }
}
