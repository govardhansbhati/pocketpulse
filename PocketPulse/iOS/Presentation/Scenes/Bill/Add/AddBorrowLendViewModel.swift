//
//  AddBorrowLendViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

/// Manages the state and logic for the `AddBorrowLendSheet`.
@MainActor
class AddBorrowLendViewModel: ObservableObject {
    @Published var name = ""
    @Published var amount = ""
    @Published var contact = ""
    @Published var type: BorrowLendType = .lent
    @Published var dueDate = Date()
    
    @Published var shouldSendReminder = true
    @Published var reminderOption: ReminderOption = .oneDayBefore
    
    private var itemToEdit: BorrowLendModel?
    var isEditing: Bool { itemToEdit != nil }

    private let useCase: BillUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    
    init(useCase: BillUseCaseProtocol, dataUpdateService: DataUpdateServiceProtocol) {
        self.useCase = useCase
        self.dataUpdateService = dataUpdateService
    }

    func setup(for item: BorrowLendModel?) {
        guard let item = item else { return }
        self.itemToEdit = item
        
        name = item.name
        amount = String(describing: item.amount)
        contact = item.contact ?? ""
        type = item.type
        dueDate = item.dueDate
        shouldSendReminder = item.reminderEnabled
        if let reminder = item.reminder {
            reminderOption = reminder
        }
    }

    func save() async -> Result<Void, ValidationError> {
        guard !name.isEmpty else { return .failure(.missingTitle(field: "Person's Name")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        
        let item = itemToEdit ?? BorrowLendModel(name: "", amount: 0, contact: nil, type: .lent)
        
        item.name = name
        item.amount = amountValue
        item.contact = contact.isEmpty ? nil : contact
        item.type = type
        item.dueDate = dueDate
        
        // --- Handle Notification Logic ---
        NotificationManager.shared.cancelNotification(for: item, type: .borrowLend)
        
        if shouldSendReminder {
            NotificationManager.shared.scheduleNotification(for: item,
                                                            type: .borrowLend,
                                                            reminderOption: reminderOption)
            item.reminderEnabled = true
            item.reminder = reminderOption
        } else {
            item.reminderEnabled = false
            item.reminder = nil
        }
        
        do {
            if isEditing {
                try await useCase.updateBorrowLend(item)
            } else {
                try await useCase.addBorrowLend(item)
            }
            // Notify update
            dataUpdateService.notifyBillUpdated()
            return .success(())
        } catch {
             print("Error saving borrow/lend: \(error)")
             return .success(())
        }
    }
}
