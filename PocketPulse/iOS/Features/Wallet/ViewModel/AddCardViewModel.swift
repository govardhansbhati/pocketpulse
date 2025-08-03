//
//  AddCardViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//

import Foundation
import SwiftUI
import SwiftData

class AddCardViewModel: ObservableObject {
    // Card Info
    @Published var cardHolderName: String = ""
    @Published var cardNumber: String = "" // Full number for input, will be processed
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
    @Published var billingDate: String = "15" // Default to 15th
    @Published var paymentDueDate: String = "5" // Default to 5th

    func save(context: ModelContext) -> Bool {
        // --- Basic Validation ---
        guard !cardHolderName.isEmpty,
              !bankName.isEmpty,
              cardNumber.count >= 4 else { // Ensure there are at least 4 digits
            return false
        }
        
        // Extract last 4 digits
        let last4 = String(cardNumber.suffix(4))

        // --- Type-Specific Validation & Creation ---
        var newCard: CardModel

        if cardType == .credit {
            guard let limit = Double(creditLimit),
                  let billDate = Int(billingDate), (1...31).contains(billDate),
                  let dueDate = Int(paymentDueDate), (1...31).contains(dueDate) else {
                return false
            }
            newCard = CardModel(
                cardHolderName: cardHolderName, last4Digits: last4, expiryDate: formattedDate(expiryDate),
                providerType: providerType, cardType: .credit, cardDesign: cardDesign, bankName: bankName,
                creditLimit: limit, billingDate: billDate, paymentDueDate: dueDate
            )
        } else { // Debit Card
            guard selectedBankAccount != nil else { return false }
            newCard = CardModel(
                cardHolderName: cardHolderName, last4Digits: last4, expiryDate: formattedDate(expiryDate),
                providerType: providerType, cardType: .debit, cardDesign: cardDesign, bankName: bankName,
                linkedBankAccount: selectedBankAccount
            )
        }

        context.insert(newCard)
        return true
    }

    func reset() {
        // Reset all fields to default
        cardHolderName = ""; cardNumber = ""; expiryDate = .now; providerType = .masterCard
        cardDesign = .black; bankName = ""; cardType = .credit; selectedBankAccount = nil
        creditLimit = ""; billingDate = "15"; paymentDueDate = "5"
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: date)
    }
}
