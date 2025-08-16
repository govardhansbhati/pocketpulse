//
//  AddCardViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Add/Edit Card Sheet & ViewModel
class AddCardViewModel: ObservableObject {
    @Published var cardHolderName: String = ""
    @Published var cardNumber: String = ""
    @Published var expiryDate: Date = .now
    @Published var providerType: CardProvider = .masterCard
    @Published var cardDesign: CardDesign = .black
    @Published var bankName: String = ""
    @Published var cardType: CardType = .credit
    @Published var selectedBankAccount: AccountModel?
    @Published var creditLimit: String = ""
    @Published var billingDate: String = ""
    @Published var paymentDueDate: String = ""
    
    private var cardToEdit: CardModel?
    var isEditing: Bool { cardToEdit != nil }

    func setup(for card: CardModel?) {
        guard let card = card else { return }
        self.cardToEdit = card
        
        cardHolderName = card.cardHolderName
        cardNumber = card.last4Digits // Note: Only show last 4 for editing
        bankName = card.bankName
        providerType = card.providerType
        cardDesign = card.cardDesign
        cardType = card.cardType
        selectedBankAccount = card.linkedBankAccount
        
        if let limit = card.creditLimit { creditLimit = String(limit) }
        if let billDate = card.billingDate { billingDate = String(billDate) }
        if let dueDate = card.paymentDueDate { paymentDueDate = String(dueDate) }
        
        // Setup expiry date from string
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        if let date = formatter.date(from: card.expiryDate) {
            expiryDate = date
        }
    }
    
    func save(context: ModelContext) -> Result<Void, ValidationError> {
        // ... (Validation logic is the same as before) ...
        
        let card = cardToEdit ?? CardModel(cardHolderName: "", last4Digits: "", expiryDate: "", providerType: .visa, cardType: .credit, cardDesign: .black, bankName: "")
        
        // Update common properties
        card.cardHolderName = cardHolderName
        card.expiryDate = formattedDate(expiryDate)
        card.providerType = providerType
        card.cardDesign = cardDesign
        card.cardType = cardType
        
        // Only update card number if it's a new card
        if !isEditing {
            guard cardNumber.count >= 13 && cardNumber.count <= 19 && cardNumber.allSatisfy({ $0.isNumber }) else {
                return .failure(.invalidCardNumber)
            }
            card.last4Digits = String(cardNumber.suffix(4))
        }

        if cardType == .credit {
            // ... (Credit card validation and property updates) ...
            card.bankName = bankName
            card.creditLimit = Double(creditLimit)
            card.billingDate = Int(billingDate)
            card.paymentDueDate = Int(paymentDueDate)
            card.linkedBankAccount = nil
        } else {
            // ... (Debit card validation and property updates) ...
            guard let linkedAccount = selectedBankAccount else { return .failure(.missingLinkedAccount) }
            card.bankName = linkedAccount.institution
            card.linkedBankAccount = linkedAccount
            card.creditLimit = nil
            card.billingDate = nil
            card.paymentDueDate = nil
        }
        
        if !isEditing {
            context.insert(card)
        }
        
        return .success(())
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: date)
    }
}
