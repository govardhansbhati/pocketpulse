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
    var notes: String?
    
    // Property to store the user's custom sort order
    var orderIndex: Int

    @Relationship(deleteRule: .cascade, inverse: \CardModel.linkedBankAccount)
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
        notes: String? = nil,
        orderIndex: Int // Added to initializer
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
        self.orderIndex = orderIndex // Assign the index
    }
}

