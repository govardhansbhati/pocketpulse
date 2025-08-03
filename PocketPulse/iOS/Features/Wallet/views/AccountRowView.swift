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
        VStack(alignment: .leading, spacing: 8) {
            // Top Row: Account Name and Balance
            HStack {
                Text(account.name)
                    .font(.headline)
                Spacer()
                // Correctly formats the balance as currency
                Text(account.balance, format: .currency(code: "INR"))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(account.balance >= 0 ? .green : .red)
            }

            // Middle Row: Institution and Account Type
            HStack(spacing: 4) {
                Image(systemName: "building.columns.fill")
                Text(account.institution)
                Spacer()
                Text(account.type.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(6)
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
                    .padding(.top, 2)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
