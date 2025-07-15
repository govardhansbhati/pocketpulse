//
//  AccountModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import SwiftData
import SwiftUI

@Model
class AccountModel {
    var id: UUID
    var name: String
    var type: AccountType
    var balance: Double
    var details: String

    @Relationship(inverse: \CardModel.linkedBankAccount)
    var linkedCards: [CardModel] = []

    init(name: String, type: AccountType, balance: Double, details: String) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.balance = balance
        self.details = details
    }
}


enum AccountType: String, Codable, CaseIterable, Identifiable {
    case savings
    case current
    case cash
    case bank
    case card
    var id: String {
        rawValue
    }
}
