//
//  ExpenseCategory.swift
//  PocketPulse
//
//  Created by govardhan singh on 16/07/25.
//

import Charts
import SwiftUI
// MARK: - Supporting Models

// A struct to hold data for the pie chart, representing spending in a specific category.
struct ExpenseCategoryStat: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}

// A struct to hold aggregated data for the bar chart
struct DailyTotal: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
    let type: TransactionType
}
