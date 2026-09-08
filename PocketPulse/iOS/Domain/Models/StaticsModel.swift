//
//  StaticsModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 16/07/25.
//

import Foundation

// MARK: - Supporting Models

// A struct to hold data for the pie chart, representing spending in a specific category.
struct ExpenseCategoryStat: Identifiable {
    let id: UUID
    let category: TransactionCategory
    let name: String
    let amount: Double
    
    init(id: UUID = UUID(), category: TransactionCategory, name: String, amount: Double) {
        self.id = id
        self.category = category
        self.name = name
        self.amount = amount
    }
}

// A struct to hold aggregated data for the bar chart
struct DailyTotal: Identifiable {
    let id: UUID
    let date: Date
    let amount: Double
    let type: TransactionType
    
    init(id: UUID = UUID(), date: Date, amount: Double, type: TransactionType) {
        self.id = id
        self.date = date
        self.amount = amount
        self.type = type
    }
}
