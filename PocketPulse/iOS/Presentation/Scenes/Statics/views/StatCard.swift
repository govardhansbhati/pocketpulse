//
//  StatCard.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/08/25.
//


import SwiftUI
import Charts

struct StatCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
            Text(title)
                .font(.subheadline)
            Text(amount, format: .currency(code: AppConstants.Currency.isoCode))
                .font(.title3.bold())
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: AppConstants.Layout.shadowRadius, x: 0, y: AppConstants.Layout.shadowY)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                        .stroke(Color.gray.opacity(0.2), lineWidth: AppConstants.Layout.borderWidth)
                )
        )
    }
}