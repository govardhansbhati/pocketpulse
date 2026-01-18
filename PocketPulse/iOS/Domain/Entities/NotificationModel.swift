//
//  NotificationModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 18/01/26.
//

import Foundation
import SwiftData

@Model
final class NotificationModel: Identifiable {
    var id: UUID
    var title: String
    var message: String
    var date: Date
    var type: NotificationCategory
    var isRead: Bool
    
    init(id: UUID = UUID(), title: String, message: String, date: Date = Date(), type: NotificationCategory, isRead: Bool = false) {
        self.id = id
        self.title = title
        self.message = message
        self.date = date
        self.type = type
        self.isRead = isRead
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
