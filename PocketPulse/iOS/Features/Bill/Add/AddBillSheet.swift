//
//  AddBillSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI

/// A view that allows the user to add a new bill or edit an existing one, including scheduling reminders.
struct AddBillSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = AddBillViewModel()
    @State private var validationError: ValidationError?
    
    /// An optional `BillModel` to pre-fill the form for editing. If `nil`, the sheet is in "add" mode.
    let billToEdit: BillModel?

    var body: some View {
        NavigationView {
            Form {
                // Section 1: Core Bill Details
                Section(header: Text("Bill Details")) {
                    TextField("Title (e.g., Internet Bill)", text: $viewModel.title)
                    TextField("Amount", text: $viewModel.amount).keyboardType(.decimalPad)
                    DatePicker("Due Date", selection: $viewModel.dueDate, in: Date()..., displayedComponents: .date)
                }
                
                // Section 2: Reminder Scheduling
                // This section allows the user to enable and configure a push notification reminder.
                Section(header: Text("Reminder")) {
                    Toggle(isOn: $viewModel.shouldSendReminder.animation()) {
                        Text("Send Reminder Notification")
                    }
                    
                    // The reminder options only appear if the toggle is on.
                    if viewModel.shouldSendReminder {
                        Picker("Remind Me", selection: $viewModel.reminderOption) {
                            ForEach(ReminderOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Bill" : "Add Bill")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { saveBill() } }
            }
            .onAppear {
                viewModel.setup(for: billToEdit)
            }
            .alert(item: $validationError) { error in
                Alert(
                    title: Text(error.alert.title),
                    message: Text(error.alert.message),
                    dismissButton: error.alert.primaryButton
                )
            }
        }
    }
    
    private func saveBill() {
        let result = viewModel.save(context: context)
        if case .failure(let error) = result {
            self.validationError = error
        } else {
            dismiss()
        }
    }
}
