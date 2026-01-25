//
//  NotificationManager.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import Foundation
import UserNotifications

// MARK: - Enums & Protocols

enum ReminderOption: String, CaseIterable, Codable, Identifiable {
    case sameDay = "Same day"
    case oneDayBefore = "1 day before"
    case twoDaysBefore = "2 days before"
    case oneWeekBefore = "1 week before"
    
    var id: String { self.rawValue }
    
    var timeInterval: TimeInterval {
        switch self {
        case .sameDay: return 0
        case .oneDayBefore: return -86400
        case .twoDaysBefore: return -172800
        case .oneWeekBefore: return -604800
        }
    }
    
    var localized: String {
        switch self {
        case .sameDay: return AppStrings.Notification.reminderSameDay
        case .oneDayBefore: return AppStrings.Notification.reminderOneDayBefore
        case .twoDaysBefore: return AppStrings.Notification.reminderTwoDaysBefore
        case .oneWeekBefore: return AppStrings.Notification.reminderOneWeekBefore
        }
    }
}

enum NotificationType {
    case bill
    case borrowLend
}

protocol NotificationSchedulable {
    var notificationId: String { get }
    var notificationTitle: String { get }
    var notificationBody: String { get }
    var notificationDate: Date { get }
}

// MARK: - Notification Manager

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    // MARK: - Daily Transaction Reminder
    
    func scheduleDailyTransactionReminder(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = AppStrings.Notification.dailyTitle
        content.body = AppStrings.Notification.dailyBody
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyTransactionReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelDailyTransactionReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["dailyTransactionReminder"])
    }
    
    // MARK: - General Notifications
    
    func scheduleNotification(for item: NotificationSchedulable,
                              type: NotificationType,
                              reminderOption: ReminderOption) {
        let content = UNMutableNotificationContent()
        content.title = item.notificationTitle
        content.body = item.notificationBody
        content.sound = .default
        
        let triggerDate = item.notificationDate.addingTimeInterval(reminderOption.timeInterval)
        
        // Ensure the trigger date is in the future.
        // If it's in the past, we could either not schedule it or schedule it immediately.
        // For now, let's only schedule future notifications.
        guard triggerDate > Date() else {
             print("Notification skipped: Trigger date is in the past.")
             return
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: item.notificationId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification for \(item.notificationId): \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotification(for item: NotificationSchedulable, type: NotificationType) {
         UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.notificationId])
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show banner and sound even when app is in foreground
        completionHandler([.banner, .sound])
    }
}
