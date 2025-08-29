//
//  AddExpenseView.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import SwiftUI
import SwiftData

// MARK: - Add Expense View 
struct AddExpenseView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = AddExpenseViewModel()
    
    // Fetch both accounts and all cards
    @Query(sort: \AccountModel.name) private var accounts: [AccountModel]
    @Query private var cards: [CardModel]
    
    @State private var validationError: ValidationError?
    
    // Combine accounts and all cards into a single list for the picker
    private var paymentSources: [AddExpenseViewModel.PaymentSource] {
        let accountSources = accounts.map { AddExpenseViewModel.PaymentSource.account($0) }
        let cardSources = cards.map { AddExpenseViewModel.PaymentSource.card($0) }
        return accountSources + cardSources
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title (e.g., Groceries)", text: $viewModel.title)
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }

                Section(header: Text("Categorization")) {
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(TransactionCategory.expenseCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Picker("Pay From", selection: $viewModel.selectedPaymentSource) {
                        Text("Select a source").tag(nil as AddExpenseViewModel.PaymentSource?)
                        ForEach(paymentSources) { source in
                            Text(source.name).tag(source as AddExpenseViewModel.PaymentSource?)
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { saveTransaction() } }
            }
            .alert(item: $validationError) { error in
                 Alert(
                    title: Text(error.alert.title),
                    message: Text(error.alert.message),
                    dismissButton: error.alert.primaryButton
                )
            }
            .onAppear {
                // Set a default payment source if one isn't selected
                if viewModel.selectedPaymentSource == nil {
                    viewModel.selectedPaymentSource = paymentSources.first
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
            self.validationError = error
        }
    }
}
