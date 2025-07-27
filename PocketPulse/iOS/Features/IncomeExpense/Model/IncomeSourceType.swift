//
//  IncomeSourceType.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import SwiftUI

enum IncomeSourceType : String, CaseIterable, Identifiable{
    case salary, freelance, business, interest, investment, rental, other
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        rawValue.capitalized
    }
}

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
