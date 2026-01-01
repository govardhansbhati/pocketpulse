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
    
    var localized: String {
        switch self {
        case .borrowed: return AppStrings.Bill.Add.typeBorrowed
        case .lent: return AppStrings.Bill.Add.typeLent
        }
    }
}

/// A view that allows the user to add or edit a borrow/lend entry, including scheduling reminders.
struct AddBorrowLendSheet: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddBorrowLendViewModel
    @State private var validationError: ValidationError?
    
    var itemToEdit: BorrowLendModel?
    var onSave: () -> Void

    init(viewModel: AddBorrowLendViewModel, itemToEdit: BorrowLendModel? = nil, onSave: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.itemToEdit = itemToEdit
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(AppStrings.Bill.Add.entryDetailsHeader)) {
                    
                    if !viewModel.isEditing {
                        Picker(AppStrings.Bill.Add.typeLabel, selection: $viewModel.type) {
                            ForEach(BorrowLendType.allCases) { type in Text(type.localized).tag(type) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    TextField(AppStrings.Bill.Add.personNamePlaceholder, text: $viewModel.name)
                    TextField(AppStrings.Bill.amountLabel, text: $viewModel.amount).keyboardType(.decimalPad)
                    DatePicker(AppStrings.Bill.dueDateLabel, selection: $viewModel.dueDate, in: Date()..., displayedComponents: .date)
                    TextField(AppStrings.Bill.Add.contactPlaceholder, text: $viewModel.contact)
                }
                
                Section(header: Text(AppStrings.Bill.Add.reminderHeader)) {
                    Toggle(isOn: $viewModel.shouldSendReminder.animation()) {
                        Text(AppStrings.Bill.Add.sendReminder)
                    }
                    
                    if viewModel.shouldSendReminder {
                        Picker(AppStrings.Bill.Add.remindMeLabel, selection: $viewModel.reminderOption) {
                            ForEach(ReminderOption.allCases) { option in
                                Text(option.localized).tag(option)
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? AppStrings.Bill.Add.editEntryTitle : AppStrings.Bill.Add.addNewEntryTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) {
                    Task { await saveEntry() }
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
            if let item = itemToEdit {
                viewModel.setup(for: item)
            }
        }
        }
    }
    
    private func saveEntry() async {
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
