//
//  AnalyticsPieChartView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/08/25.
//

import Charts
import SwiftUI

struct AnalyticsPieChartView: View {
    let expenses: [ExpenseCategoryStat]
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(spacing: AppConstants.Layout.spacingStandard) {
            Text(AppStrings.Statics.Chart.breakdown)
                .font(.title2.bold())
            
            Chart {
                ForEach(expenses) { item in
                    SectorMark(
                        angle: .value("Amount", item.amount),
                        innerRadius: .ratio(0.5),
                        angularInset: 1
                    )
                    .foregroundStyle(item.color)
                    .annotation(position: .overlay) {
                        Text("\(Int((item.amount / totalAmount) * 100))%")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
            .frame(height: AppConstants.Size.chartHeight)
            .chartLegend(.hidden)
            .overlay(
                VStack {
                    Text(AppStrings.Statics.Chart.total)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(totalAmount, format: .currency(code: AppConstants.Currency.isoCode))
                        .font(.title3.bold())
                }
            )
            
            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                ForEach(expenses) { item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: AppConstants.Size.iconMarker, height: AppConstants.Size.iconMarker)
                        Text(item.name)
                            .font(.subheadline)
                        Spacer()
                        Text(item.amount, format: .currency(code: AppConstants.Currency.isoCode))
                            .font(.subheadline.bold())
                    }
                }
            }
            .padding(.horizontal, AppConstants.Layout.paddingMedium)
        }
        .padding(AppConstants.Layout.paddingMedium)
    }
}

// MARK: - Presentation Color Mapping
extension ExpenseCategoryStat {
    var color: Color {
        category.color
    }
}

extension TransactionCategory {
    var color: Color {
        switch self {
        case .food: return Color(hex: "FF6F61")
        case .transport: return Color(hex: "03A9F4")
        case .rent: return Color(hex: "9C27B0")
        case .shopping: return Color(hex: "E91E63")
        case .health: return Color(hex: "00F5A0")
        case .entertainment: return Color(hex: "FFD700")
        case .education: return Color(hex: "3F51B5")
        case .bills: return Color(hex: "FF5722")
        case .salary: return Color(hex: "00F5A0")
        case .freelance: return Color(hex: "00B0FF")
        case .business: return Color(hex: "8E2DE2")
        case .investment: return Color(hex: "00E676")
        case .other: return Color(hex: "78909C")
        }
    }
}
