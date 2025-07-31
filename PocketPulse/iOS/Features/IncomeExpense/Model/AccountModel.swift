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
    var institution: String // e.g., "State Bank of India"
    var accountNumber: String? // Optional, as user may not want to add it
    var ifscCode: String? // Optional
    var openingDate: Date
    var status: AccountStatus
    var notes: String? // Optional

    @Relationship(inverse: \CardModel.linkedBankAccount)
    var linkedCards: [CardModel] = []

    init(
        name: String,
        type: AccountType,
        balance: Double,
        institution: String,
        accountNumber: String? = nil,
        ifscCode: String? = nil,
        openingDate: Date = .now,
        status: AccountStatus = .active,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.balance = balance
        self.institution = institution
        self.accountNumber = accountNumber
        self.ifscCode = ifscCode
        self.openingDate = openingDate
        self.status = status
        self.notes = notes
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
