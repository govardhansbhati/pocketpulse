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
        HStack(spacing: AppConstants.Layout.spacingMedium) {
            // MARK: - Category Icon (Neon Squircle)
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous) // Keep specific radius for icon shape or add constant
                    .fill(
                        LinearGradient(
                            colors: [
                                (transaction.type == .expense ? AppTheme.expense : AppTheme.income).opacity(0.2),
                                (transaction.type == .expense ? AppTheme.expense : AppTheme.income).opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(
                                (transaction.type == .expense ? AppTheme.expense : AppTheme.income).opacity(0.3),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: (transaction.type == .expense ? AppTheme.expense : AppTheme.income).opacity(0.2),
                        radius: 8, x: 0, y: 0
                    )
                
                Image(systemName: transaction.type == .expense ? AppAssets.Icons.arrowDown : AppAssets.Icons.arrowUp)
                    .font(.system(size: AppConstants.Layout.spacingMedium, weight: .bold)) // 16
                    .foregroundColor(transaction.type == .expense ? AppTheme.expense : AppTheme.income)
            }
            .frame(width: 48, height: 48) // Icon container size
            
            // MARK: - Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: AppConstants.Layout.spacingMedium, weight: .semibold, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .lineLimit(1)
                
                Text(transaction.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
            }
            
            Spacer()
            
            // MARK: - Amount Display
            Text(transaction.amount, format: .currency(code: AppConstants.Currency.isoCode))
                .font(.system(size: AppConstants.Layout.spacingMedium, weight: .bold, design: .rounded))
                .foregroundColor(transaction.type == .expense ? AppTheme.expense : AppTheme.income)
                // Add a subtle glow to the text
                .shadow(
                    color: (transaction.type == .expense ? AppTheme.expense : AppTheme.income).opacity(0.3),
                    radius: 5, x: 0, y: 0
                )
        }
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                Color.clear
            }
        )
    }
}
