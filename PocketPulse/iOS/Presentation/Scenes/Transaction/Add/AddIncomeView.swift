//
//  IncomeExpense.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftData
import SwiftUI

struct AddIncomeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: AddIncomeViewModel
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSaving = false
    
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
                            AppText.Subtitle(text: AppStrings.Transaction.Add.incomeDetails)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            GlassTextField(placeholder: AppStrings.Transaction.Add.titlePlaceholderIncome,
                                           text: $viewModel.title)
                            
                            GlassTextField(placeholder: AppStrings.Transaction.Add.amountPlaceholder,
                                           text: $viewModel.amount,
                                           keyboardType: .decimalPad)
                            
                            HStack {
                                AppText.Body(text: AppStrings.Transaction.Add.dateLabel)
                                Spacer()
                                DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding(AppConstants.Layout.paddingMedium)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                 style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                         style: .continuous)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal)

                        // Section: Categorization
                        VStack(alignment: .leading, spacing: 8) {
                            AppText.Subtitle(text: AppStrings.Transaction.Add.categorizationHeader)
                                .padding(.leading, 4)

                            GlassPicker(title: AppStrings.Transaction.Add.categoryLabel,
                                        selection: $viewModel.category,
                                        selectionLabel: viewModel.category.displayName) {
                                ForEach(TransactionCategory.incomeCases) { category in
                                    Text(category.displayName).tag(category)
                                }
                            }

                            GlassPicker(title: AppStrings.Transaction.Add.depositToLabel,
                                        selection: $viewModel.selectedAccount,
                                        selectionLabel:
                                            viewModel.selectedAccount?.name
                                            ?? AppStrings.Transaction.Add.selectAccountPlaceholder) {
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
                        .disabled(isSaving)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Button(AppStrings.Common.save) { saveTransaction() }
                    }
                }
            }
            .interactiveDismissDisabled(isSaving)
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
    
    private func saveTransaction() {
        guard !isSaving else { return }
        isSaving = true
        Task {
            let result = await viewModel.saveTransaction()
            
            switch result {
            case .success:
                await MainActor.run {
                    dismiss()
                }
            case .failure(let error):
                await MainActor.run {
                    self.isSaving = false
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}
