//
//  NotificationSchedulable.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//

import SwiftUI
// MARK: - Notification Schedulable Protocol

protocol NotificationSchedulable {
    var id: UUID { get }
    var notificationTitle: String { get }
    var notificationBody: String { get }
    var notificationDate: Date { get }
}

/// An enum representing the different reminder options a user can choose for a bill.
/// It conforms to Codable so that SwiftData can store it.
enum ReminderOption: String, Codable, CaseIterable, Identifiable {
    case onDueDate = "On due date"
    case oneDayBefore = "1 day before"
    case twoDaysBefore = "2 days before"
    case oneWeekBefore = "1 week before"
    
    var id: String { self.rawValue }
    
    /// The time interval in seconds before the due date for the notification to fire.
    var timeInterval: TimeInterval? {
        switch self {
        case .onDueDate:
            return 0
        case .oneDayBefore:
            return 24 * 60 * 60 // 1 day in seconds
        case .twoDaysBefore:
            return 2 * 24 * 60 * 60 // 2 days
        case .oneWeekBefore:
            return 7 * 24 * 60 * 60 // 1 week
        }
    }
}

enum NotificationType: String {
    case bill = "bill_reminder_"
    case borrowLend = "borrow_lend_reminder_"
    case dailyTransaction = "daily_transaction_reminder"
    
    func identifier(for id: UUID) -> String {
        return self.rawValue + id.uuidString
    }
}

// MARK: - Notification Manager
/// A singleton class to manage all local notification logic for the app.
class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    /// Requests authorization from the user to send notifications.
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Generic Schedulers
    
    /// Schedules a local push notification for any item that conforms to `NotificationSchedulable`.
    func scheduleNotification<T: NotificationSchedulable>(for item: T, type: NotificationType, reminderOption: ReminderOption) {
        let content = UNMutableNotificationContent()
        content.title = item.notificationTitle
        content.body = item.notificationBody
        content.sound = .default
        
        let triggerDate = calculateTriggerDate(for: item.notificationDate, with: reminderOption)
        
        guard let validTriggerDate = triggerDate, validTriggerDate > Date() else {
            print("Reminder date is in the past. Notification not scheduled for item: \(item.id)")
            return
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: validTriggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = type.identifier(for: item.id)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for item \(item.id) on \(validTriggerDate)")
            }
        }
    }
    
    /// Cancels a pending notification for a specific schedulable item.
    func cancelNotification<T: NotificationSchedulable>(for item: T, type: NotificationType) {
        let identifier = type.identifier(for: item.id)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Cancelled notification for item ID: \(item.id.uuidString)")
    }
    
    // MARK: - Daily Transaction Reminders (Separate Responsibility)
    
    /// Schedules a recurring daily reminder for the user to add their transactions.
    func scheduleDailyTransactionReminder(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "PocketPulse Daily Check-in"
        content.body = "Don't forget to add today's income and expenses!"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = NotificationType.dailyTransaction.rawValue
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error.localizedDescription)")
            } else {
                print("Daily transaction reminder scheduled successfully.")
            }
        }
    }
    
    /// Cancels the recurring daily transaction reminder.
    func cancelDailyTransactionReminder() {
        let identifier = NotificationType.dailyTransaction.rawValue
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Cancelled daily transaction reminder.")
    }
    
    // MARK: - Private Helper
    
    /// Calculates the precise date and time for a notification to trigger.
    private func calculateTriggerDate(for dueDate: Date, with option: ReminderOption) -> Date? {
        guard let notificationTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: dueDate) else {
            return nil
        }
        return notificationTime.addingTimeInterval(-(option.timeInterval ?? 0.0))
    }
}
