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
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Section: Expense Details
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            Text(AppStrings.Transaction.Add.expenseDetails)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            GlassTextField(placeholder: AppStrings.Transaction.Add.titlePlaceholderExpense, text: $viewModel.title)
                            
                            GlassTextField(placeholder: AppStrings.Transaction.Add.amountPlaceholder, text: $viewModel.amount, keyboardType: .decimalPad)
                            
                            // Date Picker in Glass Style (Custom approximation using standard Picker for now, wrapped)
                            HStack {
                                Text(AppStrings.Transaction.Add.dateLabel)
                                    .foregroundColor(AppTheme.adaptiveText)
                                Spacer()
                                DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding(AppConstants.Layout.paddingMedium)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal)
                        
                        // Section: Categorization
                        VStack(alignment: .leading, spacing: 8) {
                            Text(AppStrings.Transaction.Add.categorizationHeader)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, 4)
                            
                            GlassPicker(title: AppStrings.Transaction.Add.categoryLabel, selection: $viewModel.category) {
                                ForEach(TransactionCategory.expenseCases) { category in
                                    Text(category.displayName).tag(category)
                                }
                            }
                            
                            GlassPicker(title: AppStrings.Transaction.Add.payFromLabel, selection: $viewModel.selectedPaymentSource) {
                                Text(AppStrings.Transaction.Add.selectSourcePlaceholder).tag(nil as AddExpenseViewModel.PaymentSource?)
                                ForEach(viewModel.paymentSources) { source in
                                    Text(source.name).tag(source as AddExpenseViewModel.PaymentSource?)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(AppStrings.Transaction.Add.expenseTitle)
            .navigationBarTitleDisplayMode(.inline)
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
