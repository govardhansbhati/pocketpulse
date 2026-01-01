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
                Section(header: Text(AppStrings.Transaction.Add.expenseDetails)) {
                    TextField(AppStrings.Transaction.Add.titlePlaceholderExpense, text: $viewModel.title)
                    TextField(AppStrings.Transaction.Add.amountPlaceholder, text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    DatePicker(AppStrings.Transaction.Add.dateLabel, selection: $viewModel.date, displayedComponents: .date)
                }

                Section(header: Text(AppStrings.Transaction.Add.categorizationHeader)) {
                    Picker(AppStrings.Transaction.Add.categoryLabel, selection: $viewModel.category) {
                        ForEach(TransactionCategory.expenseCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Picker(AppStrings.Transaction.Add.payFromLabel, selection: $viewModel.selectedPaymentSource) {
                        Text(AppStrings.Transaction.Add.selectSourcePlaceholder).tag(nil as AddExpenseViewModel.PaymentSource?)
                        ForEach(viewModel.paymentSources) { source in
                            Text(source.name).tag(source as AddExpenseViewModel.PaymentSource?)
                        }
                    }
                }
            }
            .navigationTitle(AppStrings.Transaction.Add.expenseTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) {
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
