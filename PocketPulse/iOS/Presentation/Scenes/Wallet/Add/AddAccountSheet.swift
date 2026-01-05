//
//  AddAccountSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI
import SwiftData

// MARK: - Add Account Sheet (Updated)
struct AddAccountSheet: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddAccountViewModel
    @State private var validationError: ValidationError?
    
    var accountToEdit: AccountModel?
    var onSave: () -> Void
    
    init(viewModel: AddAccountViewModel, accountToEdit: AccountModel? = nil, onSave: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.accountToEdit = accountToEdit
        self.onSave = onSave
    }


    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Account Type
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            Text(AppStrings.Wallet.Add.accountTypeLabel)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            Picker(AppStrings.Wallet.Add.accountTypeLabel, selection: $viewModel.accountType) {
                                ForEach(AccountType.allCases) { type in
                                    Text(type.rawValue.capitalized).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .padding(.horizontal)
                        
                        // Account Details
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            Text(AppStrings.Wallet.Add.accountDetailsHeader)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            GlassTextField(placeholder: AppStrings.Wallet.Add.accountNicknamePlaceholder, text: $viewModel.accountName)
                            
                            if viewModel.accountType != .cash {
                                GlassTextField(placeholder: AppStrings.Wallet.Add.institutionPlaceholder, text: $viewModel.institution)
                            }
                            
                            GlassTextField(placeholder: AppStrings.Wallet.Add.initialBalancePlaceholder, text: $viewModel.initialBalance, keyboardType: .decimalPad)
                        }
                        .padding(.horizontal)
                        
                        // Bank Identifiers
                        if viewModel.accountType != .cash {
                            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                                Text(AppStrings.Wallet.Add.bankIdentifiersHeader)
                                    .font(.headline)
                                    .foregroundColor(AppTheme.adaptiveText)
                                    .padding(.leading, AppConstants.Layout.spacingTiny)
                                
                                GlassTextField(placeholder: AppStrings.Wallet.Add.accountNumberPlaceholder, text: $viewModel.accountNumber, keyboardType: .numberPad)
                                
                                GlassTextField(placeholder: AppStrings.Wallet.Add.ifscPlaceholder, text: $viewModel.ifscCode)
                                // Note: GlassTextField currently doesn't expose autocapitalization modifer easily unless generic.
                                // We can accept it if critical, or users will just type caps.
                            }
                            .padding(.horizontal)
                        }
                        
                        // Other Details
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            Text(AppStrings.Wallet.Add.otherDetailsHeader)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            // Date Picker
                            HStack {
                                Text(AppStrings.Wallet.Add.openingDateLabel)
                                    .foregroundColor(AppTheme.adaptiveText)
                                Spacer()
                                DatePicker("", selection: $viewModel.openingDate, in: ...Date(), displayedComponents: .date)
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
                            
                            Picker(AppStrings.Wallet.Add.statusLabel, selection: $viewModel.status) {
                                ForEach(AccountStatus.allCases) { status in Text(status.rawValue).tag(status) }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            GlassTextField(placeholder: AppStrings.Wallet.Add.notesPlaceholder, text: $viewModel.notes)
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(viewModel.isEditing ? AppStrings.Wallet.Add.editAccountTitle : AppStrings.Wallet.Add.addNewAccountTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) {
                    Task { await saveAccount() }
                } }
            }
            .alert(item: $validationError) { error in
                Alert(title: Text(error.alert.title), message: Text(error.alert.message), dismissButton: error.alert.primaryButton)
            }
            .onAppear {
                if let account = accountToEdit {
                    viewModel.setup(for: account)
                }
            }
        }
    }
    
    private func saveAccount() async {
        let result = await viewModel.save()
        switch result {
        case .success:
            await MainActor.run {
                onSave()
                dismiss()
            }
        case .failure(let error):
            await MainActor.run {
                self.validationError = error
            }
        }
    }
}
