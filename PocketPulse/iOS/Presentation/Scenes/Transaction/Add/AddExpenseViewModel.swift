//
//  AddExpenseViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import Foundation
import SwiftUI
import SwiftData

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
        guard !title.isEmpty else { return .failure(.missingTitle(field: "title")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        guard let source = selectedPaymentSource else { return .failure(.missingAccount) }

        // Create the new transaction
        var newTransaction: TransactionModel?
        
        //  Handle both account and card payments ---
        switch source {
        case .account(let account):
            //  Check for sufficient funds
            guard account.balance >= amountValue else {
                return .failure(.insufficientFunds(accountName: account.name))
            }
            
            // If paying from an account, decrease its balance
            account.balance -= amountValue
            newTransaction = TransactionModel(
                title: title, amount: amountValue, type: .expense, category: category, date: date,
                linkedAccountID: account.id // Link to the account
            )
            
            // Update Account
            do {
                try await accountUseCase.update(account: account)
            } catch {
                return .failure(.custom(message: "Failed to update account balance"))
            }
            
        case .card(let card):
            if card.cardType == .credit {
                // If paying with a credit card, increase its outstanding balance
                card.outstandingBalance = (card.outstandingBalance ?? 0) + amountValue
                // Update Card
                do {
                    try await cardUseCase.update(card: card)
                } catch {
                     return .failure(.custom(message: "Failed to update card balance"))
                }
            } else { // Debit Card
                // If paying with a debit card, decrease the linked account's balance
                guard let linkedAccount = card.linkedBankAccount else {
                    // This is a data integrity error. A debit card should always have a linked account.
                    return .failure(.custom(message: "This debit card is not linked to a bank account."))
                }
                
                // Check for sufficient funds in the linked account
                guard linkedAccount.balance >= amountValue else {
                    return .failure(.insufficientFunds(accountName: linkedAccount.name))
                }
                
                linkedAccount.balance -= amountValue
                // Update Linked Account
                do {
                    try await accountUseCase.update(account: linkedAccount)
                } catch {
                     return .failure(.custom(message: "Failed to update linked account balance"))
                }
            }
            
            newTransaction = TransactionModel(
                title: title, amount: amountValue, type: .expense, category: category, date: date,
                linkedCardID: card.id // Link the transaction to the card
            )
        }
        
        if let transaction = newTransaction {
            do {
                try await transactionUseCase.add(transaction: transaction)
                
                // Notify via service
                dataUpdateService.notifyTransactionUpdated()
                
                return .success(())
            } catch {
                return .failure(.custom(message: "Failed to save transaction"))
            }
        }
        
        return .failure(.custom(message: "Unknown error"))
    }
}
enum IncomeSourceType : String, CaseIterable, Identifiable{
    case salary, freelance, business, interest, investment, rental, other
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        rawValue.capitalized
    }
}
