//
//  AddBorrowLendSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI
import SwiftData

enum BorrowLendType: String, Codable, CaseIterable, Identifiable {
    case borrowed = "You Borrowed"
    case lent = "You Lent"
    var id: String { self.rawValue }
}

/// A view that allows the user to add or edit a borrow/lend entry, including scheduling reminders.
struct AddBorrowLendSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = AddBorrowLendViewModel()
    @State private var validationError: ValidationError?

    /// An optional `BorrowLendModel` to pre-fill the form for editing.
    let itemToEdit: BorrowLendModel?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Entry Details")) {
                    
                    if !viewModel.isEditing {
                        Picker("Type", selection: $viewModel.type) {
                            ForEach(BorrowLendType.allCases) { type in Text(type.rawValue).tag(type) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    TextField("Person's Name", text: $viewModel.name)
                    TextField("Amount", text: $viewModel.amount).keyboardType(.decimalPad)
                    DatePicker("Due Date", selection: $viewModel.dueDate, in: Date()..., displayedComponents: .date)
                    TextField("Contact Info (Optional)", text: $viewModel.contact)
                }
                
                Section(header: Text("Reminder")) {
                    Toggle(isOn: $viewModel.shouldSendReminder.animation()) {
                        Text("Send Reminder Notification")
                    }
                    
                    if viewModel.shouldSendReminder {
                        Picker("Remind Me", selection: $viewModel.reminderOption) {
                            ForEach(ReminderOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Entry" : "Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { saveEntry() } }
            }
            .onAppear {
                viewModel.setup(for: itemToEdit)
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
    
    private func saveEntry() {
        let result = viewModel.save(context: context)
        if case .failure(let error) = result {
            self.validationError = error
        } else {
            dismiss()
        }
    }
}
