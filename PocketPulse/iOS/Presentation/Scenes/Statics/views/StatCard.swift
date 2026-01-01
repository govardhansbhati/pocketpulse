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
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                Color.clear
            }
        )
    }
}