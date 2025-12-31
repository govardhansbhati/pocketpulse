//
//  AccountDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 16/08/25.
//
import SwiftUI


// MARK: - Account Detail View (New)
struct AccountDetailView: View {
    @Environment(\.presentWalletSheet) private var presentSheet
    let account: AccountModel
    
    var body: some View {
        List {
            Section("Details") {
                Text("Balance: \(account.balance, format: .currency(code: "INR"))")
                Text("Institution: \(account.institution)")
                if let accountNumber = account.accountNumber {
                    Text("Account Number: \(accountNumber)")
                }
            }
            // TODO: Add a list of transactions for this account here
        }
        .navigationTitle(account.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    presentSheet?(.addAccount(account))
                }
            }
        }
    }
}
