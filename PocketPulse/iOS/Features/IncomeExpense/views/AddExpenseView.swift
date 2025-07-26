//
//  AddExpenseView.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = AddExpenseViewModel()
    @Environment(\.dismiss) private var dismiss

    @Query private var accounts: [AccountModel]
    @State private var showAlert = false
    @State private var alertMessage = ""


    var filteredAccounts: [AccountModel] {
        switch viewModel.type {
        case .expense, .income:
            return accounts
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Transaction Info")) {
                    TextField("Title", text: $viewModel.title)
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $viewModel.category) {
                        ForEach(TransactionCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }

                Section(header: Text("Select Account/Card")) {
                    Picker("Account", selection: $viewModel.selectedAccount) {
                        ForEach(accounts, id: \.id) { account in
                            Text("\(account.name) • \(account.type.rawValue.capitalized)")
                                .tag(account as AccountModel?)
                        }
                    }
                }

                Section {
                    Button("Save") {
                        if !viewModel.validateAccountSelection(context: context) {
                            alertMessage = "Please add a valid \(viewModel.selectedAccount?.type.rawValue.capitalized ?? "account") first."
                            showAlert = true
                            return
                        }

                        if viewModel.addTransaction(context: context) {
                            viewModel.reset()
                            dismiss()
                        } else {
                            alertMessage = "Please fill all required fields correctly."
                            showAlert = true
                        }
                    }
                }
            }
            .navigationTitle("Add Transaction")
            .alert("Alert", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}
