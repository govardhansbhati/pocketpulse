//
//  ExpenseCategory.swift
//  PocketPulse
//
//  Created by govardhan singh on 16/07/25.
//


import SwiftUI
import Charts
// MARK: - Supporting Models

struct GraphData: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}

struct ExpenseCategoryStat: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}

struct AccountStat: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}


enum StatTab: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case transaction = "Transaction Stats"
    case analytics = "Analytics Stats"
}
