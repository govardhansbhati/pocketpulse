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
    @Query private var accounts: [AccountModel] // for linking debit card to bank

    @StateObject private var viewModel = AddCardViewModel()
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card Info")) {
                    TextField("Cardholder Name", text: $viewModel.cardHolderName)
                    TextField("Card Number", text: $viewModel.cardNumber)
                    DatePicker("Expiry Date", selection: $viewModel.expiryDate, displayedComponents: .date)
                    Picker("Provider", selection: $viewModel.providerType) {
                        ForEach(CardProvider.allCases) { provider in
                            Text(provider.rawValue.capitalized).tag(provider)
                        }
                    }
                    Picker("Design", selection: $viewModel.cardDesign) {
                        ForEach(CardDesign.allCases) { design in
                            Text(design.rawValue.capitalized).tag(design)
                        }
                    }
                }

                Section(header: Text("Card Type")) {
                    Picker("Type", selection: $viewModel.cardType) {
                        ForEach(CardType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    if viewModel.cardType == .debit {
                        Picker("Linked Bank Account", selection: $viewModel.selectedBankAccount) {
                            Text("Select Account").tag(nil as AccountModel?)
                            ForEach(accounts) { account in
                                Text(account.name).tag(account as AccountModel?)
                            }
                        }
                    }
                }

                Section(header: Text("Balance & Bank")) {
                    TextField("Available Balance", text: $viewModel.balance)
                        .keyboardType(.decimalPad)
                    TextField("Bank Name", text: $viewModel.bankName)
                }
            }
            .navigationTitle("Add Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.save(context: context) {
                            viewModel.reset()
                            onSave()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
