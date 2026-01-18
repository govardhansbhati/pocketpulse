//
//  NotificationCategory.swift
//  PocketPulse
//
//  Created by govardhan singh on 18/01/26.
//

import SwiftUI

enum NotificationCategory: String, Codable {
    case alert
    case info
    case success
    
    var icon: String {
        switch self {
        case .alert: return "exclamationmark.triangle.fill"
        case .info: return "bell.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .alert: return AppTheme.expense
        case .info: return AppTheme.primaryColor
        case .success: return AppTheme.income
        }
    }
}
