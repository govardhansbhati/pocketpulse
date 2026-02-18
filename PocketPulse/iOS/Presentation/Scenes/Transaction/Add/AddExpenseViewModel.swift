//
//  AddExpenseViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Add Expense ViewModel
@MainActor
class AddExpenseViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var category: TransactionCategory = .food
    @Published var date: Date = .now
    
    // --- Data Sources ---
    @Published var accounts: [AccountModel] = []
    @Published var cards: [CardModel] = []
    
    // This enum will hold the selected payment source, whether it's an account or a card.
    enum PaymentSource: Hashable, Identifiable {
        case account(AccountModel)
        case card(CardModel)
        
        var id: UUID {
            switch self {
            case .account(let acc): return acc.id
            case .card(let card): return card.id
            }
        }
        
        var name: String {
            switch self {
            case .account(let acc): return acc.name
            case .card(let card):
                // Differentiate the name based on card type
                let typeString = card.cardType.rawValue.capitalized
                return "\(card.bankName) (\(typeString))" // e.g., "HDFC (Credit)" or "SBI (Debit)"
            }
        }
    }
    
    @Published var selectedPaymentSource: PaymentSource?
    
    private let transactionUseCase: TransactionUseCaseProtocol
    private let accountUseCase: AccountUseCaseProtocol
    private let cardUseCase: CardUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    
    init(transactionUseCase: TransactionUseCaseProtocol,
         accountUseCase: AccountUseCaseProtocol,
         cardUseCase: CardUseCaseProtocol,
         dataUpdateService: DataUpdateServiceProtocol) {
        self.transactionUseCase = transactionUseCase
        self.accountUseCase = accountUseCase
        self.cardUseCase = cardUseCase
        self.dataUpdateService = dataUpdateService
    }
    
    func fetchData() async {
        do {
            self.accounts = try await accountUseCase.fetchAccounts()
            self.cards = try await cardUseCase.fetchCards()
            // Set default if needed
            if selectedPaymentSource == nil {
                generatePaymentSources()
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    private func generatePaymentSources() {
        let accountSources = accounts.map { PaymentSource.account($0) }
        let cardSources = cards.map { PaymentSource.card($0) }
        let allSources = accountSources + cardSources
        selectedPaymentSource = allSources.first
    }
    
    var paymentSources: [PaymentSource] {
        let accountSources = accounts.map { PaymentSource.account($0) }
        let cardSources = cards.map { PaymentSource.card($0) }
        return accountSources + cardSources
    }

    func saveTransaction() async -> Result<Void, ValidationError> {
        // 1. Basic Validation
        guard !title.isEmpty else { return .failure(.missingTitle(field: "title")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        guard let source = selectedPaymentSource else { return .failure(.missingAccount) }

        // 2. Process Payment based on Source Type
        let result = await createTransaction(from: source, amount: amountValue)
        
        // 3. Save Transaction if successful
        switch result {
        case .success(let transaction):
            return await persistTransaction(transaction)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTransaction(from source: PaymentSource,
                                   amount: Double) async -> Result<TransactionModel, ValidationError> {
        switch source {
        case .account(let account):
            return await processAccountPayment(account: account, amount: amount)
        case .card(let card):
            return await processCardPayment(card: card, amount: amount)
        }
    }
    
    private func persistTransaction(_ transaction: TransactionModel) async -> Result<Void, ValidationError> {
        do {
            try await transactionUseCase.add(transaction: transaction)
            dataUpdateService.notifyTransactionUpdated()
            return .success(())
        } catch {
            return .failure(.custom(message: "Failed to save transaction"))
        }
    }
    
    // MARK: - Helper Methods
    
    private func processAccountPayment(account: AccountModel,
                                       amount: Double) async -> Result<TransactionModel, ValidationError> {
        // Validation: Sufficient Funds
        guard account.balance >= amount else {
            return .failure(.insufficientFunds(accountName: account.name))
        }
        
        // Action: Deduct Balance
        account.balance -= amount
        
        // Update Account
        do {
            try await accountUseCase.update(account: account)
        } catch {
            return .failure(.custom(message: "Failed to update account balance"))
        }
        
        // Create Transaction
        let transaction = TransactionModel(
            title: title,
            amount: amount,
            type: .expense,
            category: category,
            date: date,
            linkedAccountID: account.id
        )
        return .success(transaction)
    }
    
    private func processCardPayment(card: CardModel,
                                    amount: Double) async -> Result<TransactionModel, ValidationError> {
        if card.cardType == .credit {
            return await handleCreditCardPayment(card: card, amount: amount)
        } else {
            return await handleDebitCardPayment(card: card, amount: amount)
        }
    }
    
    // MARK: - Specific Card Handlers

    private func handleCreditCardPayment(card: CardModel,
                                         amount: Double) async -> Result<TransactionModel, ValidationError> {
        // Validation: Credit Limit (if applicable)
        if let limit = card.creditLimit {
            let currentBalance = card.outstandingBalance ?? 0
            if (currentBalance + amount) > limit {
                return .failure(.creditLimitExceeded(cardName: card.bankName))
            }
        }
        
        // Action: Increase Outstanding Balance
        card.outstandingBalance = (card.outstandingBalance ?? 0) + amount
        
        // Update Card
        do {
            try await cardUseCase.update(card: card)
        } catch {
             return .failure(.custom(message: "Failed to update card balance"))
        }

        // Create Transaction
        return .success(createCardTransaction(card: card, amount: amount))
    }
    
    private func handleDebitCardPayment(card: CardModel,
                                        amount: Double) async -> Result<TransactionModel, ValidationError> {
        guard let linkedAccount = card.linkedBankAccount else {
            return .failure(.custom(message: "This debit card is not linked to a bank account."))
        }
        
        // Validation: Sufficient Funds in Linked Account
        guard linkedAccount.balance >= amount else {
             return .failure(.insufficientFunds(accountName: linkedAccount.name))
        }
        
        // Action: Deduct Balance from Linked Account
        linkedAccount.balance -= amount
        
        // Update Linked Account
        do {
            try await accountUseCase.update(account: linkedAccount)
        } catch {
             return .failure(.custom(message: "Failed to update linked account balance"))
        }
        
        // Create Transaction
        return .success(createCardTransaction(card: card, amount: amount))
    }

    private func createCardTransaction(card: CardModel, amount: Double) -> TransactionModel {
        return TransactionModel(
            title: title,
            amount: amount,
            type: .expense,
            category: category,
            date: date,
            linkedCardID: card.id
        )
    }
}
