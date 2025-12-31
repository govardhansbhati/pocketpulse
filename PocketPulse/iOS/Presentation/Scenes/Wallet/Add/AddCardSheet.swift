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
    
    @StateObject private var viewModel = AddCardViewModel()
    @State private var validationError: ValidationError?
    
    var cardToEdit: CardModel?
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                if !viewModel.isEditing {
                    Section {
                        Picker("Card Type", selection: $viewModel.cardType) {
                            ForEach(CardType.allCases) { type in Text(type.rawValue.capitalized).tag(type) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                // --- Common Card Info ---
                Section(header: Text("Card Details")) {
                    TextField("Cardholder Name", text: $viewModel.cardHolderName)
                    TextField("Full Card Number", text: $viewModel.cardNumber)
                        .keyboardType(.numberPad)
                    DatePicker("Expiry Date", selection: $viewModel.expiryDate, displayedComponents: .date)
                    
                    if viewModel.cardType == .credit {
                        TextField("Bank Name", text: $viewModel.bankName)
                    }
                    
                    Picker("Provider", selection: $viewModel.providerType) {
                        ForEach(CardProvider.allCases) { p in Text(p.rawValue.capitalized).tag(p) }
                    }
                }
                
                if viewModel.cardType == .debit {
                    Section(header: Text("Link to Bank Account")) {
                        Picker("Account", selection: $viewModel.selectedBankAccount) {
                            Text("Select Account").tag(nil as AccountModel?)
                            ForEach(accounts.filter { $0.type != .cash }) { account in
                                Text("\(account.name) (\(account.institution))").tag(account as AccountModel?)
                            }
                        }
                    }
                } else {
                    Section(header: Text("Credit Details")) {
                        TextField("Credit Limit", text: $viewModel.creditLimit)
                            .keyboardType(.decimalPad)
                        TextField("Billing Date (e.g., 15)", text: $viewModel.billingDate)
                            .keyboardType(.numberPad)
                        TextField("Payment Due Date (e.g., 5)", text: $viewModel.paymentDueDate)
                            .keyboardType(.numberPad)
                    }
                }
                
                // --- Visuals Section ---
                Section(header: Text("Card Design")) {
                    Picker("Design", selection: $viewModel.cardDesign) {
                        ForEach(CardDesign.allCases) { d in Text(d.rawValue.capitalized).tag(d) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add New Card")
            .navigationTitle(viewModel.isEditing ? "Edit Card" : "Add New Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { saveCard() } }
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
        let result = viewModel.save(context: context)
        
        switch result {
        case .success:
            onSave()
            dismiss()
        case .failure(let error):
            self.validationError = error
        }
    }
}
