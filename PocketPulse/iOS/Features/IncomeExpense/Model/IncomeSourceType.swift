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
    case food
    case transport
    case rent
    case shopping
    case health
    case salary
    case entertainment
    case education
    case bills
    case other

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .food: return "Food"
        case .transport: return "Transport"
        case .rent: return "Rent"
        case .shopping: return "Shopping"
        case .health: return "Health"
        case .salary: return "Salary"
        case .entertainment: return "Entertainment"
        case .education: return "Education"
        case .bills: return "Bills"
        case .other: return "Other"
        }
    }
}

