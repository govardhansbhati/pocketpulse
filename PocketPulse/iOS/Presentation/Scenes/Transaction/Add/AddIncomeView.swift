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
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Section: Income Details
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            Text(AppStrings.Transaction.Add.incomeDetails)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            GlassTextField(placeholder: AppStrings.Transaction.Add.titlePlaceholderIncome, text: $viewModel.title)
                            
                            GlassTextField(placeholder: AppStrings.Transaction.Add.amountPlaceholder, text: $viewModel.amount, keyboardType: .decimalPad)
                            
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

                            GlassPicker(title: AppStrings.Transaction.Add.categoryLabel, selection: $viewModel.category, selectionLabel: viewModel.category.displayName) {
                                ForEach(TransactionCategory.incomeCases) { category in
                                    Text(category.displayName).tag(category)
                                }
                            }

                            GlassPicker(title: AppStrings.Transaction.Add.depositToLabel, selection: $viewModel.selectedAccount, selectionLabel: viewModel.selectedAccount?.name ?? AppStrings.Transaction.Add.selectAccountPlaceholder) {
                                Text(AppStrings.Transaction.Add.selectAccountPlaceholder).tag(nil as AccountModel?)
                                ForEach(viewModel.accounts) { account in
                                    Text("\(account.name) (\(account.institution))")
                                        .tag(account as AccountModel?)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(AppStrings.Transaction.Add.incomeTitle)
            .navigationBarTitleDisplayMode(.inline)
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
