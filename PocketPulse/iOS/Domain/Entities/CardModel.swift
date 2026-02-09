//
//  Card.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import Combine
import SwiftData
import SwiftUI

@Model
class CardModel: Hashable {
    static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var id: UUID
    var cardHolderName: String
    var last4Digits: String // Storing only the last 4 digits for security
    var expiryDate: String
    var providerType: CardProvider
    var cardType: CardType
    var cardDesign: CardDesign
    var bankName: String
    
    //  Property to store the user's custom sort order
    var orderIndex: Int
    
    // --- Debit Card Specific ---
    @Relationship var linkedBankAccount: AccountModel?
    
    // --- Credit Card Specific (Optional) ---
    var creditLimit: Double?
    var outstandingBalance: Double?
    var billingDate: Int? // Day of the month (e.g., 15)
    var paymentDueDate: Int? // Day of the month (e.g., 5)
    
    var status: CardStatus // Added status
    
    init(
        cardHolderName: String,
        last4Digits: String,
        expiryDate: String,
        providerType: CardProvider,
        cardType: CardType,
        cardDesign: CardDesign,
        bankName: String,
        orderIndex: Int, // Added to initializer
        linkedBankAccount: AccountModel? = nil,
        creditLimit: Double? = nil,
        outstandingBalance: Double? = 0.0, // Starts at zero
        billingDate: Int? = nil,
        paymentDueDate: Int? = nil,
        status: CardStatus = .active // Default to active
    ) {
        self.id = UUID()
        self.cardHolderName = cardHolderName
        self.last4Digits = last4Digits
        self.expiryDate = expiryDate
        self.providerType = providerType
        self.cardType = cardType
        self.cardDesign = cardDesign
        self.bankName = bankName
        self.orderIndex = orderIndex
        self.linkedBankAccount = linkedBankAccount
        self.creditLimit = creditLimit
        self.outstandingBalance = outstandingBalance
        self.billingDate = billingDate
        self.paymentDueDate = paymentDueDate
        self.status = status
    }
}

enum CardStatus: String, Codable, CaseIterable, Identifiable {
    case active = "Active"
    case inactive = "Inactive"
    case blocked = "Blocked"
    case expired = "Expired"
    
    var id: String { rawValue }
}

enum CardType: String, Codable, CaseIterable, Identifiable {
    case debit, credit
    var id: String { rawValue }
}

enum CardDesign: String, Codable, CaseIterable, Identifiable {
    case black, orange, pink
    var id: String { rawValue }
}

enum CardProvider: String, Codable, CaseIterable, Identifiable {
    case masterCard, visa, rupay
    var id: String { rawValue }
}
