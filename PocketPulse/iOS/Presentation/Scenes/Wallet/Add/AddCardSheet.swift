//
//  AddCardSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftData
import SwiftUI

// MARK: - Add Card Sheet
struct AddCardSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query private var accounts: [AccountModel]
    
    @StateObject private var viewModel: AddCardViewModel
    @State private var validationError: ValidationError?
    
    var cardToEdit: CardModel?
    var onSave: () -> Void
    
    init(viewModel: AddCardViewModel, cardToEdit: CardModel? = nil, onSave: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.cardToEdit = cardToEdit
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Card Type Picker (Only if adding new)
                        if !viewModel.isEditing {
                            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                                Text(AppStrings.Wallet.Add.cardType)
                                    .font(.headline)
                                    .foregroundColor(AppTheme.adaptiveText)
                                    .padding(.leading, AppConstants.Layout.spacingTiny)
                                
                                Picker(AppStrings.Wallet.Add.cardType, selection: $viewModel.cardType) {
                                    ForEach(CardType.allCases) { type in Text(type.rawValue.capitalized).tag(type) }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .padding(.horizontal)
                        }
                        
                        // Section: Card Details
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                            Text(AppStrings.Wallet.Add.cardDetailsHeader)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, AppConstants.Layout.spacingTiny)
                            
                            GlassTextField(placeholder: AppStrings.Wallet.Add.cardHolderPlaceholder,
                                           text: $viewModel.cardHolderName)
                            
                            GlassTextField(placeholder: AppStrings.Wallet.Add.cardNumberPlaceholder,
                                           text: $viewModel.cardNumber,
                                           keyboardType: .numberPad)
                            
                            // Date Picker
                            HStack {
                                Text(AppStrings.Wallet.Add.expiryLabel)
                                    .foregroundColor(AppTheme.adaptiveText)
                                Spacer()
                                DatePicker("",
                                           selection: $viewModel.expiryDate,
                                           in: Date()...,
                                           displayedComponents: .date)
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
                            
                            if viewModel.cardType == .credit {
                                GlassTextField(placeholder: AppStrings.Wallet.Add.bankNamePlaceholder,
                                               text: $viewModel.bankName)
                            }
                            
                            GlassPicker(title: AppStrings.Wallet.Add.providerLabel,
                                        selection: $viewModel.providerType,
                                        selectionLabel: viewModel.providerType.rawValue.capitalized) {
                                ForEach(CardProvider.allCases) { provider in Text(provider.rawValue.capitalized).tag(provider)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Section: Specific Logic (Debit vs Credit)
                        if viewModel.cardType == .debit {
                            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                                Text(AppStrings.Wallet.Add.linkAccountHeader)
                                    .font(.headline)
                                    .foregroundColor(AppTheme.adaptiveText)
                                    .padding(.leading, AppConstants.Layout.spacingTiny)
                                
                                GlassPicker(title: AppStrings.Wallet.Add.accountLabel,
                                            selection: $viewModel.selectedBankAccount,
                                            selectionLabel: viewModel.selectedBankAccount?.name ?? AppStrings.Wallet.Add.selectAccountPlaceholder) {
                                    Text(AppStrings.Wallet.Add.selectAccountPlaceholder).tag(nil as AccountModel?)
                                    ForEach(accounts.filter { $0.type != .cash }) { account in
                                        Text("\(account.name) (\(account.institution))").tag(account as AccountModel?)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                                Text(AppStrings.Wallet.Add.creditDetailsHeader)
                                    .font(.headline)
                                    .foregroundColor(AppTheme.adaptiveText)
                                    .padding(.leading, AppConstants.Layout.spacingTiny)
                                
                                GlassTextField(placeholder: AppStrings.Wallet.Add.creditLimitPlaceholder,
                                               text: $viewModel.creditLimit,
                                               keyboardType: .decimalPad)
                                
                                GlassTextField(placeholder: "Current Outstanding Balance (Optional)",
                                               text: $viewModel.outstandingBalance,
                                               keyboardType: .decimalPad)
                                
                                GlassTextField(placeholder: AppStrings.Wallet.Add.billingDatePlaceholder,
                                               text: $viewModel.billingDate,
                                               keyboardType: .numberPad)
                                
                                GlassTextField(placeholder: AppStrings.Wallet.Add.dueDatePlaceholder,
                                               text: $viewModel.paymentDueDate,
                                               keyboardType: .numberPad)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Section: Visuals
                        VStack(alignment: .leading, spacing: 8) {
                            Text(AppStrings.Wallet.Add.designHeader)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, 4)
                            
                            Picker(AppStrings.Wallet.Add.designLabel,
                                   selection: $viewModel.cardDesign) {
                                ForEach(CardDesign.allCases) { design in
                                    Text(design.rawValue.capitalized)
                                        .tag(design)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(
                viewModel.isEditing ? AppStrings.Wallet.Add.editCardTitle : AppStrings.Wallet.Add.addNewCardTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) { saveCard() } }
            }
            .alert(item: $validationError) { error in
                Alert(title: Text(error.alert.title),
                      message: Text(error.alert.message),
                      dismissButton: error.alert.primaryButton)
            }
            .onAppear {
                viewModel.setup(for: cardToEdit)
            }
        }
    }
    
    private func saveCard() {
        Task {
            let result = await viewModel.save()
            
            switch result {
            case .success:
                onSave()
                dismiss()
            case .failure(let error):
                self.validationError = error
            }
        }
    }
}
