//
//  Transaction.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import Foundation
import SwiftData

@Model
class TransactionModel {
    var id: UUID
    var title: String
    var amount: Double
    var type: TransactionType
    var category: TransactionCategory
    var date: Date
    var linkedAccountID: UUID?
    var linkedCardID: UUID?
    var destinationAccountID: UUID?
    var destinationCardID: UUID?

    init(
        title: String,
        amount: Double,
        type: TransactionType,
        category: TransactionCategory,
        date: Date,
        linkedAccountID: UUID? = nil,
        linkedCardID: UUID? = nil,
        destinationAccountID: UUID? = nil,
        destinationCardID: UUID? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
        self.linkedAccountID = linkedAccountID
        self.linkedCardID = linkedCardID
        self.destinationAccountID = destinationAccountID
        self.destinationCardID = destinationCardID
    }
}

enum TransactionType: String, Codable {
    case income, expense, transfer
}
