//
//  Bill.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import SwiftUI
import SwiftData

// MARK: - Bill Model (SwiftData)
@Model
class BillModel {
    var id: UUID
    var title: String
    var amount: Double
    var dueDate: Date
    var isPaid: Bool
    
    // MARK: - Reminder Properties
    /// A flag to indicate if the user has enabled a reminder for this bill.
    var reminderEnabled: Bool
    /// Stores the specific reminder option the user selected (e.g., "1 day before").
    /// This needs to be `Codable` for SwiftData storage.
    var reminder: ReminderOption?

    init(
        title: String,
        amount: Double,
        dueDate: Date,
        isPaid: Bool = false,
        reminderEnabled: Bool = false,
        reminder: ReminderOption? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.dueDate = dueDate
        self.isPaid = isPaid
        self.reminderEnabled = reminderEnabled
        self.reminder = reminder
    }
}

// MARK: - Notification Schedulable Conformance
/// This extension allows the `BillModel` to work directly with the generic `NotificationManager`.
extension BillModel: NotificationSchedulable {
    /// The unique identifier for the notification, derived from the model's ID.
    var notificationId: String { "bill_\(id.uuidString)" }
    
    /// The title of the notification alert.
    var notificationTitle: String { "Upcoming Bill Reminder" }
    
    /// The body text of the notification alert.
    var notificationBody: String {
        // Create a NumberFormatter to correctly format the currency.
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = AppConstants.Currency.isoCode
        
        // Use the formatter to create the currency string.
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        
        return "Your bill for \"\(title)\" of \(formattedAmount) is due soon."
    }
    
    /// The date the notification should be scheduled for.
    var notificationDate: Date { dueDate }
}

