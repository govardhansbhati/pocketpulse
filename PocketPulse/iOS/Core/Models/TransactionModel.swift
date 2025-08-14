//
//  Transaction.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI
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

    init(
        title: String,
        amount: Double,
        type: TransactionType,
        category: TransactionCategory,
        date: Date,
        linkedAccountID: UUID? = nil,
        linkedCardID: UUID? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
        self.linkedAccountID = linkedAccountID
        self.linkedCardID = linkedCardID
    }
}


enum TransactionType: String, Codable {
    case income, expense
}
