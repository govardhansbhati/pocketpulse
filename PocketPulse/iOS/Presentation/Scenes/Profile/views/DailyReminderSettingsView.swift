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
        ZStack {
            BackgroundView()
            
            VStack(spacing: AppConstants.Layout.spacingLarge) {
                // Header
                Text(AppStrings.Profile.DailyReminder.header)
                    .font(.headline)
                    .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.high))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, AppConstants.Layout.spacingLarge)
                
                // Toggle
                GlassToggle(title: AppStrings.Profile.DailyReminder.enable, isOn: $isReminderEnabled.animation())
                    .padding(.horizontal)
                
                // Time Picker
                if isReminderEnabled {
                    HStack {
                        Text(AppStrings.Profile.DailyReminder.timeLabel)
                            .font(.body)
                            .foregroundColor(AppTheme.adaptiveText)
                        Spacer()
                        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .colorScheme(.dark) // Force dark mode/glass look for picker if needed
                    }
                    .padding(AppConstants.Layout.paddingMedium)
                    .background(
                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                            Color.white.opacity(AppConstants.Opacity.ultraFaint)
                        }
                    )
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Footer
                Text(AppStrings.Profile.DailyReminder.footer)
                    .font(.caption)
                    .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.medium))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                
                Spacer()
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
