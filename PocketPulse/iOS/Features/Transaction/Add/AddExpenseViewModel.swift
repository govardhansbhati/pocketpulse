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
class AddExpenseViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var category: TransactionCategory = .food
    @Published var date: Date = .now
    
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

    func saveTransaction(context: ModelContext) -> Result<Void, ValidationError> {
        guard !title.isEmpty else { return .failure(.missingTitle(field: "title")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        guard let source = selectedPaymentSource else { return .failure(.missingAccount) }

        // Create the new transaction
        let newTransaction: TransactionModel
        
        //  Handle both account and card payments ---
        switch source {
        case .account(let account):
            // If paying from an account, decrease its balance
            account.balance -= amountValue
            newTransaction = TransactionModel(
                title: title, amount: amountValue, type: .expense, category: category, date: date,
                linkedAccountID: account.id // Link to the account
            )
            
        case .card(let card):
            if card.cardType == .credit {
                // If paying with a credit card, increase its outstanding balance
                card.outstandingBalance = (card.outstandingBalance ?? 0) + amountValue
            } else { // Debit Card
                // If paying with a debit card, decrease the linked account's balance
                guard let linkedAccount = card.linkedBankAccount else {
                    // This is a data integrity error. A debit card should always have a linked account.
                    return .failure(.custom(message: "This debit card is not linked to a bank account."))
                }
                linkedAccount.balance -= amountValue
            }
            
            newTransaction = TransactionModel(
                title: title, amount: amountValue, type: .expense, category: category, date: date,
                linkedCardID: card.id // Link the transaction to the card
            )
        }
        
        context.insert(newTransaction)
        return .success(())
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

enum TransactionCategory: String, CaseIterable, Identifiable, Codable {
    case food, transport, rent, shopping, health, entertainment, education, bills
    case salary, freelance, business, investment, other
    var id: String { self.rawValue }
    var displayName: String { rawValue.capitalized }
    
    static var expenseCases: [TransactionCategory] {
        [.food, .transport, .rent, .shopping, .health, .entertainment, .education, .bills, .other]
    }
    static var incomeCases: [TransactionCategory] {
        [.salary, .freelance, .business, .investment, .other]
    }
}
