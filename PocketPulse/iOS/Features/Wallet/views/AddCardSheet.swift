//
//  AddCardSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI
import SwiftData

struct AddCardSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query private var accounts: [AccountModel]

    @StateObject private var viewModel = AddCardViewModel()
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                // --- Card Type Picker ---
                Section {
                    Picker("Card Type", selection: $viewModel.cardType) {
                        ForEach(CardType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // --- Common Card Info ---
                Section(header: Text("Card Details")) {
                    TextField("Cardholder Name", text: $viewModel.cardHolderName)
                    TextField("Full Card Number", text: $viewModel.cardNumber)
                        .keyboardType(.numberPad)
                    DatePicker("Expiry Date", selection: $viewModel.expiryDate, displayedComponents: .date)
                    TextField("Bank Name", text: $viewModel.bankName)
                    Picker("Provider", selection: $viewModel.providerType) {
                        ForEach(CardProvider.allCases) { p in Text(p.rawValue.capitalized).tag(p) }
                    }
                }

                // --- Conditional Fields ---
                if viewModel.cardType == .debit {
                    // --- Debit Card Section ---
                    Section(header: Text("Link to Bank Account")) {
                        Picker("Account", selection: $viewModel.selectedBankAccount) {
                            Text("Select Account").tag(nil as AccountModel?)
                            ForEach(accounts.filter { $0.type != .cash }) { account in
                                Text(account.name).tag(account as AccountModel?)
                            }
                        }
                    }
                } else {
                    // --- Credit Card Section ---
                    Section(header: Text("Credit Details")) {
                        TextField("Credit Limit", text: $viewModel.creditLimit)
                            .keyboardType(.decimalPad)
                        TextField("Billing Date (Day of Month)", text: $viewModel.billingDate)
                            .keyboardType(.numberPad)
                        TextField("Payment Due Date (Day of Month)", text: $viewModel.paymentDueDate)
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.save(context: context) {
                            onSave()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
