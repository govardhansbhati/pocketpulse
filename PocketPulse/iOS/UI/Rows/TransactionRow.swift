//
//  TransactionCell.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI

struct TransactionRow: View {
    let transaction: TransactionModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingTiny) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: AppConstants.Layout.spacingSmall) { // Standardized 6 to 8 (Small)
                Image(systemName: transaction.type == .expense ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                    .foregroundColor(transaction.type == .expense ? .red : .green)
                Text(transaction.amount, format: .currency(code: AppConstants.Currency.isoCode))
                    .foregroundColor(transaction.type == .expense ? .red : .green)
                    .fontWeight(.semibold)
            }
        }
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                .fill(Color(.systemBackground))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                        .stroke(Color.gray.opacity(0.2), lineWidth: AppConstants.Layout.borderWidth)
                })
                .shadow(color: Color.black.opacity(0.05), radius: AppConstants.Layout.shadowRadius, x: 0, y: AppConstants.Layout.shadowY)
        )
    }
}
