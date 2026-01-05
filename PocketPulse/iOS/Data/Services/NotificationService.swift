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
        let descriptor = FetchDescriptor<NotificationEntity>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        let entities = try context.fetch(descriptor)
        return entities.map { $0.toModel() }
    }
    
    func markAllAsRead() async throws {
        let descriptor = FetchDescriptor<NotificationEntity>() // Fetch all
        let entities = try context.fetch(descriptor)
        
        for entity in entities {
            entity.isRead = true
        }
        
        try context.save()
    }
    
    func addNotification(title: String, message: String, type: NotificationCategory) async throws {
        let entity = NotificationEntity(
            title: title,
            message: message,
            type: type
        )
        context.insert(entity)
        try context.save()
    }
    
    func deleteNotification(id: UUID) async throws {
        let descriptor = FetchDescriptor<NotificationEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
        }
    }
}
