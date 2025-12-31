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
                    Picker("Account Type", selection: $viewModel.accountType) {
                        ForEach(AccountType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Details")) {
                    TextField("Account Nickname", text: $viewModel.accountName)
                    if viewModel.accountType != .cash {
                        TextField("Institution (e.g., SBI, HDFC)", text: $viewModel.institution)
                    }
                    TextField("Initial Balance", text: $viewModel.initialBalance)
                        .keyboardType(.decimalPad)
                }
                
                if viewModel.accountType != .cash {
                    Section(header: Text("Bank Identifiers (Optional)")) {
                        TextField("Account Number", text: $viewModel.accountNumber).keyboardType(.numberPad)
                        TextField("IFSC Code", text: $viewModel.ifscCode).autocapitalization(.allCharacters)
                    }
                }
                
                Section(header: Text("Other Details (Optional)")) {
                    DatePicker("Opening Date", selection: $viewModel.openingDate, displayedComponents: .date)
                    Picker("Status", selection: $viewModel.status) {
                        ForEach(AccountStatus.allCases) { status in Text(status.rawValue).tag(status) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    TextField("Notes (e.g., 'Salary account')", text: $viewModel.notes)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Account" : "Add New Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") {
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
