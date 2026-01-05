//
//  NotificationDomain.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import Foundation
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

struct NotificationModel: Identifiable, Codable {
    let id: UUID
    let title: String
    let message: String
    let date: Date
    let type: NotificationCategory
    var isRead: Bool
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

protocol NotificationUseCaseProtocol {
    func loadNotifications() async throws -> [NotificationModel]
    func markAllAsRead() async throws
}


class NotificationUseCase: NotificationUseCaseProtocol {
    let service: NotificationServiceProtocol
    
    init(service: NotificationServiceProtocol) {
        self.service = service
    }
    
    func loadNotifications() async throws -> [NotificationModel] {
        try await service.fetchNotifications()
    }
    
    func markAllAsRead() async throws {
        try await service.markAllAsRead()
    }
}
