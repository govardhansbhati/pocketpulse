//
//  TransactionCategory.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import Foundation

enum TransactionCategory: String, CaseIterable, Identifiable, Codable {
    case food, transport, rent, shopping, health, entertainment, education, bills
    case salary, freelance, business, investment, other
    var id: String { self.rawValue }
    var displayName: String { rawValue.capitalized }
    
    static var expenseCases: [TransactionCategory] {
        [.food, .transport, .rent, .shopping, .health, .entertainment, .education, .bills, .other]
    }
    static var incomeCases: [TransactionCategory] {
        [.salary, .freelance, .business, .investment, .other]
    }
}
