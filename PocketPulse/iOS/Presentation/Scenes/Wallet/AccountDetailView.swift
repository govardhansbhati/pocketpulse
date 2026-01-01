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
            Section(AppStrings.Wallet.detailsSection) {
                Text("\(AppStrings.Wallet.balanceLabel): \(account.balance, format: .currency(code: "INR"))")
                Text("\(AppStrings.Wallet.institutionLabel): \(account.institution)")
                if let accountNumber = account.accountNumber {
                    Text("\(AppStrings.Wallet.accountNumberLabel): \(accountNumber)")
                }
            }
            // TODO: Add a list of transactions for this account here
        }
        .navigationTitle(account.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(AppStrings.Wallet.editAction) {
                    presentSheet?(.addAccount(account))
                }
            }
        }
    }
}
