//
//  TransactionCell.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI

struct TransactionRow: View {
    let transaction: TransactionModel
    
    private var typeColor: Color {
        switch transaction.type {
        case .expense: return AppTheme.expense
        case .income: return AppTheme.income
        case .transfer: return Color(hex: "03A9F4")
        }
    }
    
    private var typeIcon: String {
        switch transaction.type {
        case .expense: return AppAssets.Icons.arrowDown
        case .income: return AppAssets.Icons.arrowUp
        case .transfer: return AppAssets.Icons.arrowLeftArrowRight
        }
    }
    
    var body: some View {
        HStack(spacing: AppConstants.Layout.spacingMedium) {
            // MARK: - Category Icon (Neon Squircle)
            ZStack {
                RoundedRectangle(cornerRadius: 14,
                                 style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                typeColor.opacity(0.2),
                                typeColor.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(
                                typeColor.opacity(0.3),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: typeColor.opacity(0.2),
                        radius: 8,
                        x: 0,
                        y: 0
                    )
                
                Image(systemName: typeIcon)
                    .font(.system(size: AppConstants.Layout.spacingMedium, weight: .bold)) // 16
                    .foregroundColor(typeColor)
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
                .foregroundColor(typeColor)
                // Add a subtle glow to the text
                .shadow(
                    color: typeColor.opacity(0.3),
                    radius: 5,
                    x: 0,
                    y: 0
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
