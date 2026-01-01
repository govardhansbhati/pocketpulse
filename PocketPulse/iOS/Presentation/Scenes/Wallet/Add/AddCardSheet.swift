//
//  AddCardSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI
import SwiftData

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
            Form {
                if !viewModel.isEditing {
                    Section {
                        Picker(AppStrings.Wallet.Add.cardType, selection: $viewModel.cardType) {
                            ForEach(CardType.allCases) { type in Text(type.rawValue.capitalized).tag(type) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                // --- Common Card Info ---
                Section(header: Text(AppStrings.Wallet.Add.cardDetailsHeader)) {
                    TextField(AppStrings.Wallet.Add.cardHolderPlaceholder, text: $viewModel.cardHolderName)
                    TextField(AppStrings.Wallet.Add.cardNumberPlaceholder, text: $viewModel.cardNumber)
                        .keyboardType(.numberPad)
                    DatePicker(AppStrings.Wallet.Add.expiryLabel, selection: $viewModel.expiryDate, displayedComponents: .date)
                    
                    if viewModel.cardType == .credit {
                        TextField(AppStrings.Wallet.Add.bankNamePlaceholder, text: $viewModel.bankName)
                    }
                    
                    Picker(AppStrings.Wallet.Add.providerLabel, selection: $viewModel.providerType) {
                        ForEach(CardProvider.allCases) { p in Text(p.rawValue.capitalized).tag(p) }
                    }
                }
                
                if viewModel.cardType == .debit {
                    Section(header: Text(AppStrings.Wallet.Add.linkAccountHeader)) {
                        Picker(AppStrings.Wallet.Add.accountLabel, selection: $viewModel.selectedBankAccount) {
                            Text(AppStrings.Wallet.Add.selectAccountPlaceholder).tag(nil as AccountModel?)
                            ForEach(accounts.filter { $0.type != .cash }) { account in
                                Text("\(account.name) (\(account.institution))").tag(account as AccountModel?)
                            }
                        }
                    }
                } else {
                    Section(header: Text(AppStrings.Wallet.Add.creditDetailsHeader)) {
                        TextField(AppStrings.Wallet.Add.creditLimitPlaceholder, text: $viewModel.creditLimit)
                            .keyboardType(.decimalPad)
                        TextField(AppStrings.Wallet.Add.billingDatePlaceholder, text: $viewModel.billingDate)
                            .keyboardType(.numberPad)
                        TextField(AppStrings.Wallet.Add.dueDatePlaceholder, text: $viewModel.paymentDueDate)
                            .keyboardType(.numberPad)
                    }
                }
                
                // --- Visuals Section ---
                Section(header: Text(AppStrings.Wallet.Add.designHeader)) {
                    Picker(AppStrings.Wallet.Add.designLabel, selection: $viewModel.cardDesign) {
                        ForEach(CardDesign.allCases) { d in Text(d.rawValue.capitalized).tag(d) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle(viewModel.isEditing ? AppStrings.Wallet.Add.editCardTitle : AppStrings.Wallet.Add.addNewCardTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(AppStrings.Common.cancel) { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button(AppStrings.Common.save) { saveCard() } }
            }
            .alert(item: $validationError) { error in
                Alert(title: Text(error.alert.title), message: Text(error.alert.message), dismissButton: error.alert.primaryButton)
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
