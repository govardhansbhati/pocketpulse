//
//  TransactionCategory.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import Foundation

enum TransactionCategory: String, CaseIterable, Identifiable, Codable {
    case food, transport, rent, shopping, health, entertainment, education, bills
    case salary, freelance, business, investment, family, other
    var id: String { self.rawValue }
    var displayName: String { rawValue.capitalized }
    
    var iconName: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .rent: return "house.fill"
        case .shopping: return "cart.fill"
        case .health: return "cross.case.fill"
        case .entertainment: return "tv.fill"
        case .education: return "book.fill"
        case .bills: return "bolt.fill"
        case .salary: return "briefcase.fill"
        case .freelance: return "laptopcomputer"
        case .business: return "chart.bar.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .family: return "person.2.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    static var expenseCases: [TransactionCategory] {
        [.food, .transport, .rent, .shopping, .health, .entertainment, .education, .bills, .family, .other]
    }
    static var incomeCases: [TransactionCategory] {
        [.salary, .freelance, .business, .investment, .family, .other]
    }
}
