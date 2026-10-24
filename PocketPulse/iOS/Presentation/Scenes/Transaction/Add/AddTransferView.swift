//
//  AddTransferView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/10/26.
//

import SwiftData
import SwiftUI

struct AddTransferView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddTransferViewModel
    
    @State private var validationError: ValidationError?
    @State private var isSaving = false
    
    init(viewModel: AddTransferViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: AppConstants.Layout.spacingLarge) {
                        // Section: Amount & Date
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            AppText.Subtitle(text: AppStrings.Transaction.Add.transferDetails)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            GlassTextField(
                                placeholder: AppStrings.Transaction.Add.amountPlaceholder,
                                text: $viewModel.amount,
                                keyboardType: .decimalPad
                            )
                            
                            GlassTextField(
                                placeholder: AppStrings.Transaction.Add.titlePlaceholderTransfer,
                                text: $viewModel.title
                            )
                            
                            // Date Picker in Glass Style
                            HStack {
                                AppText.Body(text: AppStrings.Transaction.Add.dateLabel)
                                Spacer()
                                DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding(AppConstants.Layout.paddingMedium)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                    style: .continuous
                                )
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(
                                        cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                        style: .continuous
                                    )
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            )
                        }
                        .padding(.horizontal)
                        
                        // Section: From & To Accounts
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            AppText.Subtitle(text: "Accounts")
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            // Transfer Route Visual Card
                            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                                VStack(spacing: AppConstants.Layout.spacingMedium) {
                                    // From Account Picker
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(AppStrings.Transaction.Add.fromAccountLabel)
                                            .font(.caption)
                                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                                        
                                        GlassPicker(
                                            title: AppStrings.Transaction.Add.fromAccountLabel,
                                            selection: $viewModel.selectedFromAccount,
                                            selectionLabel: formatAccountLabel(viewModel.selectedFromAccount)
                                        ) {
                                            ForEach(viewModel.accounts) { account in
                                                Text("\(account.name) (\(account.institution)) - \(account.balance.formatted(.currency(code: AppConstants.Currency.isoCode)))")
                                                    .tag(account as AccountModel?)
                                            }
                                        }
                                    }
                                    
                                    // Transfer Direction Indicator
                                    HStack {
                                        Rectangle()
                                            .fill(Color.white.opacity(0.15))
                                            .frame(height: 1)
                                        
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: "03A9F4").opacity(0.2))
                                                .frame(width: 32, height: 32)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color(hex: "03A9F4").opacity(0.4), lineWidth: 1)
                                                )
                                            Image(systemName: AppAssets.Icons.arrowDown)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(Color(hex: "03A9F4"))
                                        }
                                        
                                        Rectangle()
                                            .fill(Color.white.opacity(0.15))
                                            .frame(height: 1)
                                    }
                                    .padding(.vertical, 2)
                                    
                                    // To Account Picker
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(AppStrings.Transaction.Add.toAccountLabel)
                                            .font(.caption)
                                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                                        
                                        GlassPicker(
                                            title: AppStrings.Transaction.Add.toAccountLabel,
                                            selection: $viewModel.selectedToAccount,
                                            selectionLabel: formatAccountLabel(viewModel.selectedToAccount)
                                        ) {
                                            ForEach(viewModel.availableToAccounts) { account in
                                                Text("\(account.name) (\(account.institution)) - \(account.balance.formatted(.currency(code: AppConstants.Currency.isoCode)))")
                                                    .tag(account as AccountModel?)
                                            }
                                        }
                                    }
                                }
                                .padding(AppConstants.Layout.paddingMedium)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(AppStrings.Transaction.Add.transferTitle)
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
                        Button(AppStrings.Common.save) { saveTransfer() }
                    }
                }
            }
            .interactiveDismissDisabled(isSaving)
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
    
    private func formatAccountLabel(_ account: AccountModel?) -> String {
        guard let account = account else {
            return AppStrings.Transaction.Add.selectAccountPlaceholder
        }
        return "\(account.name) (\(account.balance.formatted(.currency(code: AppConstants.Currency.isoCode))))"
    }
    
    private func saveTransfer() {
        guard !isSaving else { return }
        isSaving = true
        Task {
            let result = await viewModel.saveTransfer()
            switch result {
            case .success:
                await MainActor.run {
                    dismiss()
                }
            case .failure(let error):
                await MainActor.run {
                    self.isSaving = false
                    self.validationError = error
                }
            }
        }
    }
}
