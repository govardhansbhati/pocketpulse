//
//  AddAccountSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI

struct AddAccountSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var accountName = ""
    @State private var accountType = "Savings"
    @State private var amount = ""
    @State private var details = ""
    
    var onSave: (BankAccount) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Account Name", text: $accountName)
                Picker("Account Type", selection: $accountType) {
                    Text("Savings").tag("Savings")
                    Text("Current").tag("Current")
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Details", text: $details)
            }
            .navigationTitle("Add Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amt = Double(amount) {
                            let newAccount = BankAccount(accountName: accountName, accountType: accountType, amount: amt, details: details)
                            onSave(newAccount)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
