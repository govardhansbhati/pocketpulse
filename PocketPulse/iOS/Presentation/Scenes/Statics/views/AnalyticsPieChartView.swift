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
        VStack(spacing: 16) {
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
            .frame(height: 250)
            .chartLegend(.hidden)
            .overlay(
                VStack {
                    Text(AppStrings.Statics.Chart.total)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(totalAmount, format: .currency(code: "INR"))
                        .font(.title3.bold())
                }
            )
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(expenses) { item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: 12, height: 12)
                        Text(item.name)
                            .font(.subheadline)
                        Spacer()
                        Text(item.amount, format: .currency(code: "INR"))
                            .font(.subheadline.bold())
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}