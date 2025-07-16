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


// MARK: - TimeFilter Logic

extension TimeFilter {
    func contains(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()

        switch self {
        case .thisWeek:
            return calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear)
        case .thisMonth:
            return calendar.isDate(date, equalTo: now, toGranularity: .month)
        case .custom:
            return false // handled in ViewModel via customStartDate/customEndDate
        }
    }
}


// MARK: - Random Color Helper

extension Color {
    static var random: Color {
        let colors: [Color] = [.blue, .green, .purple, .orange, .pink, .red, .cyan]
        return colors.randomElement() ?? .blue
    }
}


