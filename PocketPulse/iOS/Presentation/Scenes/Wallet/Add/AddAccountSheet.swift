//
//  AddAccountSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI
import SwiftData

// MARK: - Add Account Sheet (Updated)
struct AddAccountSheet: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddAccountViewModel
    @State private var validationError: ValidationError?
    
    var accountToEdit: AccountModel?
    var onSave: () -> Void
    
    init(viewModel: AddAccountViewModel, accountToEdit: AccountModel? = nil, onSave: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.accountToEdit = accountToEdit
        self.onSave = onSave
    }


    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(AppStrings.Wallet.Add.accountTypeLabel, selection: $viewModel.accountType) {
                        ForEach(AccountType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text(AppStrings.Wallet.Add.accountDetailsHeader)) {
                    TextField(AppStrings.Wallet.Add.accountNicknamePlaceholder, text: $viewModel.accountName)
                    if viewModel.accountType != .cash {
                        TextField(AppStrings.Wallet.Add.institutionPlaceholder, text: $viewModel.institution)
                    }
                    TextField(AppStrings.Wallet.Add.initialBalancePlaceholder, text: $viewModel.initialBalance)
                        .keyboardType(.decimalPad)
                }
                
                if viewModel.accountType != .cash {
                    Section(header: Text(AppStrings.Wallet.Add.bankIdentifiersHeader)) {
                        TextField(AppStrings.Wallet.Add.accountNumberPlaceholder, text: $viewModel.accountNumber).keyboardType(.numberPad)
                        TextField(AppStrings.Wallet.Add.ifscPlaceholder, text: $viewModel.ifscCode).autocapitalization(.allCharacters)
                    }
                }
                
                Section(header: Text(AppStrings.Wallet.Add.otherDetailsHeader)) {
                    DatePicker(AppStrings.Wallet.Add.openingDateLabel, selection: $viewModel.openingDate, displayedComponents: .date)
                    Picker(AppStrings.Wallet.Add.statusLabel, selection: $viewModel.status) {
                        ForEach(AccountStatus.allCases) { status in Text(status.rawValue).tag(status) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    TextField(AppStrings.Wallet.Add.notesPlaceholder, text: $viewModel.notes)
                }
            }
            .navigationTitle(viewModel.isEditing ? AppStrings.Wallet.Add.editAccountTitle : AppStrings.Wallet.Add.addNewAccountTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) {
                    Task { await saveAccount() }
                } }
            }
            .alert(item: $validationError) { error in
                Alert(title: Text(error.alert.title), message: Text(error.alert.message), dismissButton: error.alert.primaryButton)
            }
            .onAppear {
                if let account = accountToEdit {
                    viewModel.setup(for: account)
                }
            }
        }
    }
    
    private func saveAccount() async {
        let result = await viewModel.save()
        switch result {
        case .success:
            await MainActor.run {
                onSave()
                dismiss()
            }
        case .failure(let error):
            await MainActor.run {
                self.validationError = error
            }
        }
    }
}
