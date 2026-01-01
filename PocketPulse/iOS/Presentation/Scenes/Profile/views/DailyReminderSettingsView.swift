//
//  DailyReminderSettingsView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//
import SwiftUI

/// A view that allows the user to configure their daily transaction reminder.
struct DailyReminderSettingsView: View {
    // MARK: - Properties
    
    // State properties to hold the user's preferences.
    // They are initialized from UserDefaults to persist the settings.
    @State private var isReminderEnabled: Bool
    @State private var reminderTime: Date

    // Keys for storing settings in UserDefaults.
    private let reminderEnabledKey = "dailyReminderEnabled"
    private let reminderTimeKey = "dailyReminderTime"

    init() {
        // Load the saved 'enabled' state, defaulting to false.
        _isReminderEnabled = State(initialValue: UserDefaults.standard.bool(forKey: reminderEnabledKey))
        
        // Load the saved time. If no time is saved, default to 8:00 PM.
        let savedTimeInterval = UserDefaults.standard.double(forKey: reminderTimeKey)
        if savedTimeInterval > 0 {
            _reminderTime = State(initialValue: Date(timeIntervalSince1970: savedTimeInterval))
        } else {
            // Default to 8:00 PM (20:00).
            var components = DateComponents()
            components.hour = 20
            components.minute = 0
            _reminderTime = State(initialValue: Calendar.current.date(from: components) ?? Date())
        }
    }

    // MARK: - Body
    var body: some View {
        Form {
            Section(
                header: Text(AppStrings.Profile.DailyReminder.header),
                footer: Text(AppStrings.Profile.DailyReminder.footer)
            ) {
                // A toggle to turn the reminder on or off.
                Toggle(AppStrings.Profile.DailyReminder.enable, isOn: $isReminderEnabled.animation())

                // The time picker is only shown when the reminder is enabled.
                if isReminderEnabled {
                    DatePicker(AppStrings.Profile.DailyReminder.timeLabel, selection: $reminderTime, displayedComponents: .hourAndMinute)
                }
            }
        }
        .navigationTitle(AppStrings.Profile.DailyReminder.title)
        .navigationBarTitleDisplayMode(.inline)
        // Use .onChange to react to user input, save the settings, and schedule/cancel the notification.
        .onChange(of: isReminderEnabled, { _, isEnabled in
            UserDefaults.standard.set(isEnabled, forKey: reminderEnabledKey)
            
            if isEnabled {
                NotificationManager.shared.scheduleDailyTransactionReminder(at: reminderTime)
            } else {
                NotificationManager.shared.cancelDailyTransactionReminder()
            }
        })
        .onChange(of: reminderTime, { _, newTime in
            // If the reminder is already enabled, reschedule it with the new time.
            if isReminderEnabled {
                UserDefaults.standard.set(newTime.timeIntervalSince1970, forKey: reminderTimeKey)
                NotificationManager.shared.scheduleDailyTransactionReminder(at: newTime)
            }
        })
    }
}
