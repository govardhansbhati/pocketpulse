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

    init(name: String, type: AccountType, balance: Double) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.balance = balance
    }
}

enum AccountType: String, Codable {
    case cash
    case bank
    case card
}
