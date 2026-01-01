//
//  AccountRowView.swift
//  PocketPulse
//
//  Created by govardhan singh on 27/07/25.
//

import SwiftUI

struct AccountRowView: View {
    let account: AccountModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
            // Top Row: Account Name and Balance
            HStack {
                Text(account.name)
                    .font(.headline)
                Spacer()
                // Correctly formats the balance as currency
                Text(account.balance, format: .currency(code: AppConstants.Currency.isoCode))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(account.balance >= 0 ? .green : .red)
            }
            
            // Middle Row: Institution and Account Type
            HStack(spacing: AppConstants.Layout.spacingTiny) {
                Image(systemName: AppAssets.Icons.buildingColumnsFill)
                Text(account.institution)
                Spacer()
                Text(account.type.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, AppConstants.Layout.paddingTagHorizontal)
                    .padding(.vertical, AppConstants.Layout.paddingTagVertical)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(AppConstants.Layout.cornerRadiusTag)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            // Optional Details: Only show if they exist
            if let accountNumber = account.accountNumber, !accountNumber.isEmpty {
                HStack {
                    Text("A/c:")
                        .fontWeight(.medium)
                    Text(accountNumber)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            // Notes: Only show if they exist
            if let notes = account.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.gray)
                    .padding(.top, AppConstants.Layout.paddingTopNano)
            }
        }
        .padding(AppConstants.Layout.paddingMedium)
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                Color.clear
            }
        )
    }
}
