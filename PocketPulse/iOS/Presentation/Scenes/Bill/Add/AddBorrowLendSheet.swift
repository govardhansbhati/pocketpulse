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
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Section 1: Entry Details
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            AppText.Subtitle(text: AppStrings.Bill.Add.entryDetailsHeader)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            if !viewModel.isEditing {
                                Picker(AppStrings.Bill.Add.typeLabel, selection: $viewModel.type) {
                                    ForEach(BorrowLendType.allCases) { type in Text(type.localized).tag(type) }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.bottom, AppConstants.Layout.paddingSmall)
                            }
                            
                            GlassTextField(placeholder: AppStrings.Bill.Add.personNamePlaceholder,
                                           text: $viewModel.name)
                            
                            GlassTextField(placeholder: AppStrings.Bill.amountLabel,
                                           text: $viewModel.amount,
                                           keyboardType: .decimalPad)
                            
                            GlassTextField(placeholder: AppStrings.Bill.Add.contactPlaceholder,
                                           text: $viewModel.contact)
                            
                            // Date Picker
                            HStack {
                                AppText.Body(text: AppStrings.Bill.dueDateLabel)
                                Spacer()
                                DatePicker("", selection: $viewModel.dueDate, in: Date()..., displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding(AppConstants.Layout.paddingMedium)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                 style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                         style: .continuous)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal)
                        
                        // Section 2: Reminder Scheduling
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            AppText.Subtitle(text: AppStrings.Bill.Add.reminderHeader)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            // Glass Toggle
                            HStack {
                                AppText.Body(text: AppStrings.Bill.Add.sendReminder)
                                Spacer()
                                Toggle("", isOn: $viewModel.shouldSendReminder.animation())
                                    .labelsHidden()
                            }
                            .padding(AppConstants.Layout.paddingMedium)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                 style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                         style: .continuous)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            
                            if viewModel.shouldSendReminder {
                                GlassPicker(title: AppStrings.Bill.Add.remindMeLabel,
                                            selection: $viewModel.reminderOption,
                                            selectionLabel: viewModel.reminderOption.localized) {
                                    ForEach(ReminderOption.allCases) { option in
                                        Text(option.localized).tag(option)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(viewModel.isEditing ? AppStrings.Bill.Add.editEntryTitle : AppStrings.Bill.Add.addNewEntryTitle)
            .navigationBarTitleDisplayMode(.inline)
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
