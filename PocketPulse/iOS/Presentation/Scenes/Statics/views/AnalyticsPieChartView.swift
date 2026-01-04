//
//  AnalyticsPieChartView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/08/25.
//


import SwiftUI
import Charts

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