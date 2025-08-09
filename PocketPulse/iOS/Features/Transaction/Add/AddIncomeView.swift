//
//  IncomeExpense.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import SwiftData

struct AddIncomeView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = AddIncomeViewModel()
    @Query(sort: \AccountModel.name) private var accounts: [AccountModel]
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                // Section for transaction details
                Section(header: Text("Income Details")) {
                    TextField("Title (e.g., Salary)", text: $viewModel.title)
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }

                // Section for categorization
                Section(header: Text("Categorization")) {
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(TransactionCategory.incomeCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Picker("Deposit to Account", selection: $viewModel.selectedAccount) {
                        Text("Select an account").tag(nil as AccountModel?)
                        ForEach(accounts) { account in
                            Text("\(account.name) (\(account.institution))")
                                .tag(account as AccountModel?)
                        }
                    }
                }
            }
            .navigationTitle("Add Income")
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
