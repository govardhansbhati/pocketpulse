//
//  SpendingTrendsChart.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftUI
import Charts

// MARK: - Spending Trends Chart
struct SpendingTrendsChart: View {
    let data: [DailyTotal]
    
    // Compute cumulative or smooth data if needed, but for now we'll plot daily totals directly as a line
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(AppStrings.Statics.spendingTrends)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.adaptiveText)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                .padding(.leading)
                .padding(.top, 20)
            
            if data.isEmpty {
                ContentUnavailableView("No Data", systemImage: AppAssets.Icons.chartXYAxisLine)
                    .frame(height: 220)
            } else {
                Chart(data) { point in
                    LineMark(
                        x: .value("Date", point.date, unit: .day),
                        y: .value("Amount", point.amount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Date", point.date, unit: .day),
                        y: .value("Amount", point.amount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppTheme.primaryColor.opacity(0.3), AppTheme.primaryColor.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisValueLabel(format: .dateTime.weekday(.narrow))
                            .foregroundStyle(AppTheme.adaptiveText.opacity(0.7))
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                            .foregroundStyle(AppTheme.adaptiveText.opacity(0.1))
                        AxisValueLabel()
                            .foregroundStyle(AppTheme.adaptiveText.opacity(0.7))
                    }
                }
                .frame(height: 220)
                .padding()
            }
        }
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusExtraLarge) { Color.clear }
        )
    }
}
