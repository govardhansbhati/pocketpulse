//
//  AddBillViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

/// Manages the state and logic for the `AddBillSheet`.
@MainActor
class AddBillViewModel: ObservableObject {
    @Published var title = ""
    @Published var amount = ""
    @Published var dueDate = Date()
    
    // --- Reminder Properties ---
    /// Controls whether a notification should be scheduled for this bill.
    @Published var shouldSendReminder = true
    /// The selected reminder option (e.g., 1 day before).
    @Published var reminderOption: ReminderOption = .oneDayBefore
    
    private var billToEdit: BillModel?
    var isEditing: Bool { billToEdit != nil }

    private let useCase: BillUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    
    init(useCase: BillUseCaseProtocol, dataUpdateService: DataUpdateServiceProtocol) {
        self.useCase = useCase
        self.dataUpdateService = dataUpdateService
    }

    func setup(for bill: BillModel?) {
        guard let bill = bill else { return }
        self.billToEdit = bill
        
        title = bill.title
        amount = String(describing: bill.amount)
        dueDate = bill.dueDate
        // When editing, check if a reminder was previously set.
        shouldSendReminder = bill.reminderEnabled
        if let reminder = bill.reminder {
            reminderOption = reminder
        }
    }

    func save() async -> Result<Void, ValidationError> {
        guard !title.isEmpty else { return .failure(.missingTitle(field: "Bill Title")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        
        let bill = billToEdit ?? BillModel(title: "", amount: 0, dueDate: Date())
        
        bill.title = title
        bill.amount = amountValue
        bill.dueDate = dueDate
        
        // --- Handle Notification Logic ---
        // First, cancel any existing notification for this bill to avoid duplicates.
        NotificationManager.shared.cancelNotification(for: bill, type: .bill)
        
        if shouldSendReminder {
            // If reminders are enabled, schedule a new notification and save the setting.
            NotificationManager.shared.scheduleNotification(for: bill, type: .bill, reminderOption: reminderOption)
            bill.reminderEnabled = true
            bill.reminder = reminderOption
        } else {
            // If reminders are disabled, ensure the stored properties are cleared.
            bill.reminderEnabled = false
            bill.reminder = nil
        }
        
        do {
            if isEditing {
                try await useCase.updateBill(bill)
            } else {
                try await useCase.addBill(bill)
            }
            // Notify update
            dataUpdateService.notifyBillUpdated()
            return .success(())
        } catch {
            print("Error saving bill: \(error)")
            return .success(())
        }
    }
}
