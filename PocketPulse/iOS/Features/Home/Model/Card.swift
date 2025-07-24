//
//  Card.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import SwiftUI
import Combine
import SwiftData

@Model
class CardModel {
    var id: UUID
    var cardNumber: String
    var expiryDate: String
    var cardHolderName: String
    var providerType: CardProvider
    var cardType: CardType
    var cardDesign: CardDesign
    var balance: Double
    var bankName: String

    @Relationship var linkedBankAccount: AccountModel?

    init(cardNumber: String, expiryDate: String, cardHolderName: String, providerType: CardProvider, cardType: CardType, cardDesign: CardDesign, balance: Double, bankName: String, linkedBankAccount: AccountModel? = nil) {
        self.id = UUID()
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
        self.cardHolderName = cardHolderName
        self.providerType = providerType
        self.cardType = cardType
        self.cardDesign = cardDesign
        self.balance = balance
        self.bankName = bankName
        self.linkedBankAccount = linkedBankAccount
    }
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
