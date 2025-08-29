//
//  BorrowLendModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

@Model
class BorrowLendModel {
    var id: UUID
    var name: String
    var amount: Double
    var contact: String?
    var type: BorrowLendType
    var isSettled: Bool
    
    // MARK: - New Properties for Reminders
    /// The date when the borrowed/lent amount is due to be settled.
    var dueDate: Date
    /// A flag to indicate if the user has enabled a reminder for this entry.
    var reminderEnabled: Bool
    /// Stores the specific reminder option the user selected.
    var reminder: ReminderOption?

    init(
        name: String,
        amount: Double,
        contact: String?,
        type: BorrowLendType,
        isSettled: Bool = false,
        dueDate: Date = Date(),
        reminderEnabled: Bool = false,
        reminder: ReminderOption? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.contact = contact
        self.type = type
        self.isSettled = isSettled
        self.dueDate = dueDate
        self.reminderEnabled = reminderEnabled
        self.reminder = reminder
    }
}

// MARK: - Notification Schedulable Conformance
extension BorrowLendModel: NotificationSchedulable {
    var notificationId: String { "borrowLend_\(id.uuidString)" }
    
    var notificationTitle: String { "Settle-up Reminder" }
    
    var notificationBody: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        
        switch type {
        case .borrowed:
            return "Reminder to pay back \(name) the amount of \(formattedAmount)."
        case .lent:
            return "Reminder to collect \(formattedAmount) from \(name)."
        }
    }
    
    var notificationDate: Date { dueDate }
}
