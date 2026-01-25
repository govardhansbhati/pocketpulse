//
//  NotificationService.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import Foundation
import SwiftData

protocol NotificationServiceProtocol {
    func fetchNotifications() async throws -> [NotificationModel]
    func markAllAsRead() async throws
    func addNotification(title: String, message: String, type: NotificationCategory) async throws
    func deleteNotification(id: UUID) async throws
}

@MainActor
class NotificationService: NotificationServiceProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchNotifications() async throws -> [NotificationModel] {
        let descriptor = FetchDescriptor<NotificationModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func markAllAsRead() async throws {
        let descriptor = FetchDescriptor<NotificationModel>() // Fetch all
        let notifications = try context.fetch(descriptor)
        
        for notification in notifications {
            notification.isRead = true
        }
        
        try context.save()
    }
    
    func addNotification(title: String, message: String, type: NotificationCategory) async throws {
        let notification = NotificationModel(
            title: title,
            message: message,
            type: type
        )
        context.insert(notification)
        try context.save()
    }
    
    func deleteNotification(id: UUID) async throws {
        let descriptor = FetchDescriptor<NotificationModel>(predicate: #Predicate { $0.id == id })
        if let notification = try context.fetch(descriptor).first {
            context.delete(notification)
            try context.save()
        }
    }
}
