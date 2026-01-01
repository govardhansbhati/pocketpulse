//
//  IncomeExpense.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import SwiftData

struct AddIncomeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: AddIncomeViewModel
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: AddIncomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Section for transaction details
                Section(header: Text(AppStrings.Transaction.Add.incomeDetails)) {
                    TextField(AppStrings.Transaction.Add.titlePlaceholderIncome, text: $viewModel.title)
                    TextField(AppStrings.Transaction.Add.amountPlaceholder, text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    DatePicker(AppStrings.Transaction.Add.dateLabel, selection: $viewModel.date, displayedComponents: .date)
                }

                // Section for categorization
                Section(header: Text(AppStrings.Transaction.Add.categorizationHeader)) {
                    Picker(AppStrings.Transaction.Add.categoryLabel, selection: $viewModel.category) {
                        ForEach(TransactionCategory.incomeCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Picker(AppStrings.Transaction.Add.depositToLabel, selection: $viewModel.selectedAccount) {
                        Text(AppStrings.Transaction.Add.selectAccountPlaceholder).tag(nil as AccountModel?)
                        ForEach(viewModel.accounts) { account in
                            Text("\(account.name) (\(account.institution))")
                                .tag(account as AccountModel?)
                        }
                    }
                }
            }
            .navigationTitle(AppStrings.Transaction.Add.incomeTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppStrings.Common.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppStrings.Common.save) {
                        Task { await saveTransaction() }
                    }
                }
            }
            .alert(AppStrings.Common.error, isPresented: $showAlert) {
                Button(AppStrings.Common.ok) { }
            } message: {
                Text(alertMessage)
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
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}
