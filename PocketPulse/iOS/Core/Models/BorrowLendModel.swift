//
//  BorrowLendModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

@Model
class BorrowLendModel {
    var id: UUID
    var name: String
    var amount: Double
    var contact: String? // Optional contact info
    var type: BorrowLendType // To distinguish between borrowed and lent money
    var isSettled: Bool // To track if the debt is settled

    init(name: String, amount: Double, contact: String?, type: BorrowLendType, isSettled: Bool = false) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.contact = contact
        self.type = type
        self.isSettled = isSettled
    }
}

// Enum to specify the type of transaction
enum BorrowLendType: String, Codable, CaseIterable, Identifiable {
    case borrowed = "You Borrowed"
    case lent = "You Lent"
    var id: String { self.rawValue }
}
