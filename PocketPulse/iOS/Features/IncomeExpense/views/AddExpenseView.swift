//
//  AddExpenseView.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = AddExpenseViewModel()
    @Query(sort: \AccountModel.name) private var accounts: [AccountModel]
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                // Section for transaction details
                Section(header: Text("Expense Details")) {
                    TextField("Title (e.g., Groceries)", text: $viewModel.title)
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }

                // Section for categorization
                Section(header: Text("Categorization")) {
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(TransactionCategory.expenseCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Picker("Pay from Account", selection: $viewModel.selectedAccount) {
                        Text("Select an account").tag(nil as AccountModel?)
                        ForEach(accounts) { account in
                            Text("\(account.name) (\(account.institution))")
                                .tag(account as AccountModel?)
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                if viewModel.selectedAccount == nil {
                    viewModel.selectedAccount = accounts.first
                }
            }
        }
    }
    
    private func saveTransaction() {
        let result = viewModel.saveTransaction(context: context)
        
        switch result {
        case .success:
            dismiss()
        case .failure(let error):
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}

