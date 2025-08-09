//
//  AddAccountSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI
import SwiftData

struct AddAccountSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @StateObject private var viewModel = AddAccountViewModel()
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                // SECTION 1: Core Details
                Section(header: Text("Core Details")) {
                    TextField("Account Nickname", text: $viewModel.accountName)
                    TextField("Institution (e.g., SBI, HDFC)", text: $viewModel.institution)
                    Picker("Account Type", selection: $viewModel.accountType) {
                        ForEach(AccountType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                }

                // SECTION 2: Financial Details
                Section(header: Text("Financials")) {
                    TextField("Initial Balance", text: $viewModel.initialBalance)
                        .keyboardType(.decimalPad)
                    DatePicker("Opening Date", selection: $viewModel.openingDate, displayedComponents: .date)
                }
                
                // SECTION 3: Optional Bank Details
                Section(header: Text("Bank Identifiers (Optional)")) {
                    TextField("Account Number", text: $viewModel.accountNumber)
                        .keyboardType(.numberPad)
                    TextField("IFSC Code", text: $viewModel.ifscCode)
                        .autocapitalization(.allCharacters)
                }
                
                // SECTION 4: Status and Notes
                Section(header: Text("Status & Notes")) {
                    Picker("Status", selection: $viewModel.status) {
                        ForEach(AccountStatus.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextField("Notes (e.g., 'Salary account')", text: $viewModel.notes)
                }
            }
            .navigationTitle("Add New Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.save(context: context) {
                            viewModel.reset()
                            onSave()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
