//
//  TimeFilter.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/08/25.
//

import SwiftUI
import Charts

enum TimeFilter: String, CaseIterable, Identifiable {
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case custom = "Custom"
    
    var id: String { self.rawValue }
    
    var localized: String {
        switch self {
        case .thisWeek: return AppStrings.Statics.Filter.thisWeek
        case .thisMonth: return AppStrings.Statics.Filter.thisMonth
        case .custom: return AppStrings.Statics.Filter.custom
        }
    }
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
