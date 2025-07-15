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
                Section(header: Text("Account Details")) {
                    TextField("Account Name", text: $viewModel.accountName)

                    Picker("Account Type", selection: $viewModel.accountType) {
                        ForEach(AccountType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }

                    TextField("Initial Balance", text: $viewModel.amount)
                        .keyboardType(.decimalPad)

                    TextField("Bank/Branch Details", text: $viewModel.details)
                }
            }
            .navigationTitle("Add Account")
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
