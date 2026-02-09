//
//  BalanceBreakdownSheet.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 21/08/25.
//

import SwiftData
import SwiftUI

// MARK: - Balance Breakdown Sheet
/// A view presented as a sheet that shows a detailed list of all accounts
/// contributing to the total balance.
struct BalanceBreakdownSheet: View {
    @Environment(\.dismiss) var dismiss
    
    /// The array of accounts passed in from the parent view.
    let accounts: [AccountModel]
    
    /// The total balance, calculated from the accounts.
    private var totalBalance: Double {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    var body: some View {
        NavigationView {
            List {
                // Section for the overall total
                Section {
                    HStack {
                        Text(AppStrings.Home.Breakdown.totalBalance)
                            .font(.headline)
                        Spacer()
                        Text(totalBalance, format: .currency(code: AppConstants.Currency.isoCode))
                            .fontWeight(.bold)
                    }
                }
                
                // Section for the individual account breakdown
                Section(header: Text(AppStrings.Common.accounts)) {
                    ForEach(accounts) { account in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(account.name)
                                    .font(.headline)
                                Text(account.institution)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(account.balance, format: .currency(code: AppConstants.Currency.isoCode))
                        }
                    }
                }
            }
            .navigationTitle(AppStrings.Home.Breakdown.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(AppStrings.Common.done) {
                        dismiss()
                    }
                }
            }
        }
    }
}
