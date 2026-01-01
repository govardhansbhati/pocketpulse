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
    @StateObject private var viewModel: AddBillViewModel
    @State private var validationError: ValidationError?
    
    var billToEdit: BillModel?
    var onSave: () -> Void
    
    init(viewModel: AddBillViewModel, billToEdit: BillModel? = nil, onSave: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.billToEdit = billToEdit
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                // Section 1: Core Bill Details
                Section(header: Text(AppStrings.Bill.Add.billDetailsHeader)) {
                    TextField(AppStrings.Bill.Add.titlePlaceholder, text: $viewModel.title)
                    TextField(AppStrings.Bill.amountLabel, text: $viewModel.amount).keyboardType(.decimalPad)
                    DatePicker(AppStrings.Bill.dueDateLabel, selection: $viewModel.dueDate, in: Date()..., displayedComponents: .date)
                }
                
                // Section 2: Reminder Scheduling
                // This section allows the user to enable and configure a push notification reminder.
                Section(header: Text(AppStrings.Bill.Add.reminderHeader)) {
                    Toggle(isOn: $viewModel.shouldSendReminder.animation()) {
                        Text(AppStrings.Bill.Add.sendReminder)
                    }
                    
                    // The reminder options only appear if the toggle is on.
                    if viewModel.shouldSendReminder {
                        Picker(AppStrings.Bill.Add.remindMeLabel, selection: $viewModel.reminderOption) {
                            ForEach(ReminderOption.allCases) { option in
                                Text(option.localized).tag(option)
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? AppStrings.Bill.Add.editBillTitle : AppStrings.Bill.Add.addNewBillTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) {
                    Task { await saveBill() }
                } }
            }
            .alert(item: $validationError) { error in
                Alert(
                    title: Text(error.alert.title),
                    message: Text(error.alert.message),
                    dismissButton: error.alert.primaryButton
                )
            }
        .onAppear {
            if let bill = billToEdit {
                viewModel.setup(for: bill)
            }
        }
        }
    }
    
    private func saveBill() async {
        let result = await viewModel.save()
        if case .failure(let error) = result {
            await MainActor.run {
                self.validationError = error
            }
        } else {
            await MainActor.run {
                onSave()
                dismiss()
            }
        }
    }
}
