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
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Section 1: Core Bill Details
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            AppText.Subtitle(text: AppStrings.Bill.Add.billDetailsHeader)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            GlassTextField(placeholder: AppStrings.Bill.Add.titlePlaceholder, text: $viewModel.title)
                            
                            GlassTextField(placeholder: AppStrings.Bill.amountLabel,
                                           text: $viewModel.amount,
                                           keyboardType: .decimalPad)
                            
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
            .navigationTitle(viewModel.isEditing ?
                             AppStrings.Bill.Add.editBillTitle : AppStrings.Bill.Add.addNewBillTitle)
            .navigationBarTitleDisplayMode(.inline)
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
