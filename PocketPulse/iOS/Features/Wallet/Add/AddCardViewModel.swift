//
//  AddCardViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Add Card ViewModel
class AddCardViewModel: ObservableObject {
    // Card Info
    @Published var cardHolderName: String = ""
    @Published var cardNumber: String = ""
    @Published var expiryDate: Date = .now
    @Published var providerType: CardProvider = .masterCard
    @Published var cardDesign: CardDesign = .black
    @Published var bankName: String = "" 
    
    // Card Type
    @Published var cardType: CardType = .credit
    
    // Debit Card Fields
    @Published var selectedBankAccount: AccountModel?
    
    // Credit Card Fields
    @Published var creditLimit: String = ""
    @Published var billingDate: String = ""
    @Published var paymentDueDate: String = ""

    /// Validates all inputs and saves a new CardModel to the context.
    /// - Returns: A `Result` indicating success or a specific `ValidationError`.
    func save(context: ModelContext) -> Result<Void, ValidationError> {
        guard !cardHolderName.isEmpty else {
            return .failure(.missingTitle(field: "Cardholder Name"))
        }
        guard cardNumber.count >= 13 && cardNumber.count <= 19 && cardNumber.allSatisfy({ $0.isNumber }) else {
            return .failure(.invalidCardNumber)
        }
        
        // Extract last 4 digits
        let last4 = String(cardNumber.suffix(4))

        // --- Type-Specific Validation & Creation ---
        let newCard: CardModel

        if cardType == .credit {
            // --- Credit Card Logic ---
            guard !bankName.isEmpty else {
                return .failure(.missingTitle(field: "Bank Name"))
            }
            guard let limit = Double(creditLimit), limit > 0 else {
                return .failure(.invalidCreditCardDetails(field: "Credit Limit"))
            }
            guard let billDate = Int(billingDate), (1...31).contains(billDate) else {
                return .failure(.invalidCreditCardDetails(field: "Billing Date"))
            }
            guard let dueDate = Int(paymentDueDate), (1...31).contains(dueDate) else {
                return .failure(.invalidCreditCardDetails(field: "Payment Due Date"))
            }
            
            newCard = CardModel(
                cardHolderName: cardHolderName, last4Digits: last4, expiryDate: formattedDate(expiryDate),
                providerType: providerType, cardType: .credit, cardDesign: cardDesign, bankName: bankName,
                creditLimit: limit, billingDate: billDate, paymentDueDate: dueDate
            )
        } else { // --- Debit Card Logic ---
            guard let linkedAccount = selectedBankAccount else {
                return .failure(.missingLinkedAccount)
            }
            
            newCard = CardModel(
                cardHolderName: cardHolderName, last4Digits: last4, expiryDate: formattedDate(expiryDate),
                providerType: providerType, cardType: .debit, cardDesign: cardDesign,
                bankName: linkedAccount.institution,
                linkedBankAccount: linkedAccount
            )
        }

        context.insert(newCard)
        return .success(())
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: date)
    }
}
