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
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: AddExpenseViewModel
    
    @State private var validationError: ValidationError?
    
    init(viewModel: AddExpenseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                        ForEach(viewModel.paymentSources) { source in
                            Text(source.name).tag(source as AddExpenseViewModel.PaymentSource?)
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") {
                    Task { await saveTransaction() }
                } }
            }
            .alert(item: $validationError) { error in
                 Alert(
                    title: Text(error.alert.title),
                    message: Text(error.alert.message),
                    dismissButton: error.alert.primaryButton
                )
            }
            .task {
                await viewModel.fetchData()
            }
        }
    }
    
    private func saveTransaction() async {
        let result = await viewModel.saveTransaction()
        switch result {
        case .success:
            dismiss()
        case .failure(let error):
            self.validationError = error
        }
    }
}
