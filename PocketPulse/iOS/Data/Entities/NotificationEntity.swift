//
//  NotificationEntity.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import Foundation
import SwiftData

@Model
final class NotificationEntity {
    var id: UUID
    var title: String
    var message: String
    var date: Date
    var type: String // Stored as raw string of NotificationCategory
    var isRead: Bool
    
    init(id: UUID = UUID(), title: String, message: String, date: Date = Date(), type: NotificationCategory, isRead: Bool = false) {
        self.id = id
        self.title = title
        self.message = message
        self.date = date
        self.type = type.rawValue
        self.isRead = isRead
    }
    
    var category: NotificationCategory {
        get { NotificationCategory(rawValue: type) ?? .info }
        set { type = newValue.rawValue }
    }
    
    func toModel() -> NotificationModel {
        NotificationModel(
            id: id,
            title: title,
            message: message,
            date: date,
            type: category,
            isRead: isRead
        )
    }
}
