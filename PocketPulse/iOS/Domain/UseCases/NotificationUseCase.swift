//
//  NotificationDomain.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import Foundation
import SwiftUI

// Definitions moved to iOS/Domain/Entities/NotificationCategory.swift and NotificationModel.swift

@MainActor
protocol NotificationUseCaseProtocol {
    func loadNotifications() async throws -> [NotificationModel]
    func markAllAsRead() async throws
}

@MainActor
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
