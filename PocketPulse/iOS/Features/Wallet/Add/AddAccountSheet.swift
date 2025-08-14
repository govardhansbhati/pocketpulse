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
    @Environment(\.modelContext) var context
    
    @StateObject private var viewModel = AddAccountViewModel()
    @State private var validationError: ValidationError?
    
    var onSave: () -> Void
    
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
                
                // SECTION 1: Core Details
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
                        TextField("Account Number", text: $viewModel.accountNumber)
                            .keyboardType(.numberPad)
                        TextField("IFSC Code", text: $viewModel.ifscCode)
                            .autocapitalization(.allCharacters)
                    }
                }
                
                // SECTION 4: Status and Notes
                if viewModel.accountType != .cash {
                    Section(header: Text("Other Details (Optional)")) {
                        DatePicker("Opening Date", selection: $viewModel.openingDate, displayedComponents: .date)
                        Picker("Status", selection: $viewModel.status) {
                            ForEach(AccountStatus.allCases) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        TextField("Notes (e.g., 'Salary account')", text: $viewModel.notes)
                    }
                }
                
            }
            .navigationTitle("Add New Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { saveAccount() } }
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
    
    private func saveAccount() {
        let result = viewModel.save(context: context)
        switch result {
        case .success:
            onSave()
            dismiss()
        case .failure(let error):
            self.validationError = error
        }
    }
}
