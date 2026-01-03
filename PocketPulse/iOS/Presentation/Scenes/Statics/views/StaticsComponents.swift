//
//  StaticsComponents.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftUI
import Charts

// MARK: - Time Capsule Selector
struct TimeCapsuleSelector: View {
    @Binding var selectedFilter: TimeFilter
    var onSelect: (TimeFilter) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppConstants.Layout.spacingMedium) {
                ForEach(TimeFilter.allCases) { filter in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = filter
                        }
                        onSelect(filter)
                    }) {
                        Text(filter.localized)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(selectedFilter == filter ? AppTheme.textLight : AppTheme.adaptiveText)
                            .padding(.vertical, AppConstants.Layout.paddingSmall)
                            .padding(.horizontal, AppConstants.Layout.paddingMedium)
                            .background(
                                ZStack {
                                    if selectedFilter == filter {
                                        Capsule()
                                            .fill(Color.white)
                                            .matchedGeometryEffect(id: "FILTER_CAPSULE", in: namespace)
                                            .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                                    } else {
                                        Capsule()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            .background(.ultraThinMaterial)
                                            .clipShape(Capsule())
                                    }
                                }
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10) // Space for shadow
        }
    }
    @Namespace private var namespace
}

// MARK: - Equalizer Bar Chart
struct EqualizerChart: View {
    let data: [DailyTotal]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(AppStrings.Statics.dailyTotals)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.adaptiveText)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1) // Softer shadow
                .padding(.leading)
                .padding(.top, 20)
            
            if data.isEmpty {
                 ContentUnavailableView("No Data", systemImage: AppAssets.Icons.chartBarXaxis)
                    .frame(height: AppConstants.Size.chartHeight)
            } else {
                Chart(data) { point in
                    BarMark(
                        x: .value("Date", point.date, unit: .day),
                        y: .value("Amount", point.amount),
                        width: .fixed(16)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                (point.type == .income ? AppTheme.income : AppTheme.expense),
                                (point.type == .income ? AppTheme.income : AppTheme.expense).opacity(0.3)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(4)
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
                // Reflection Effect
                .background(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.05), .clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .mask(
                            // Fade out top
                            LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top)
                        )
                        .scaleEffect(y: -0.3, anchor: .bottom) // Mirror reflection at bottom
                        .offset(y: 220 * 0.3) // Move down
                        .opacity(0.3)
                        .blur(radius: 2)
                )
            }
        }
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusExtraLarge) { Color.clear }
        )
    }
}

// MARK: - Energy Ring Chart
struct EnergyRingChart: View {
    let categoryStats: [ExpenseCategoryStat]
    @State private var selectedCategory: ExpenseCategoryStat?
    
    var totalAmount: Double {
        categoryStats.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(AppStrings.Statics.spendingByCategory)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.adaptiveText)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1) // Softer shadow since text adapts
                .padding(.leading)
                .padding(.top, 20)
            
            ZStack {
                // Glow Background
                Circle()
                    .fill(
                        AngularGradient(
                            colors: categoryStats.isEmpty ? [.gray.opacity(0.1)] : categoryStats.map { $0.color },
                            center: .center
                        )
                    )
                    .opacity(0.1)
                    .blur(radius: 20)
                    .frame(width: 200, height: 200)
                
                Chart(categoryStats) { stat in
                    SectorMark(
                        angle: .value("Amount", stat.amount),
                        innerRadius: .ratio(0.65),
                        outerRadius: .ratio(0.95),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(stat.color)
                    .shadow(radius: 5)
                }
                .frame(height: 220)
                .chartBackground { proxy in
                    GeometryReader { geo in
                        if let selected = selectedCategory {
                            // Selected Detail
                            VStack(spacing: 2) {
                                Text(selected.name)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                                Text(selected.amount, format: .currency(code: AppConstants.Currency.isoCode))
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(AppTheme.adaptiveText)
                            }
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        } else {
                            // Total Default
                            VStack(spacing: 2) {
                                AppText.Caption(text: AppStrings.Statics.totalLabel, color: AppTheme.adaptiveText.opacity(0.7))
                                Text(totalAmount, format: .currency(code: AppConstants.Currency.isoCode))
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(AppTheme.adaptiveText)
                            }
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        }
                    }
                }
                // Legend
            }
            .padding()
            
            // Legend Grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: AppConstants.Layout.spacingMedium) {
                ForEach(categoryStats) { stat in
                    HStack {
                        Circle()
                            .fill(stat.color)
                            .frame(width: 8, height: 8)
                            .shadow(color: stat.color, radius: 3)
                        Text(stat.name)
                            .font(.caption)
                            .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                        Spacer()
                        Text(stat.amount, format: .currency(code: AppConstants.Currency.isoCode))
                            .font(.caption)
                            .bold()
                            .foregroundColor(AppTheme.adaptiveText)
                    }
                    .padding(AppConstants.Layout.paddingSmall)
                    .background(.ultraThinMaterial.opacity(0.3))
                    .cornerRadius(AppConstants.Layout.cornerRadiusSmall)
                    .onTapGesture {
                        withAnimation {
                            if selectedCategory?.id == stat.id {
                                selectedCategory = nil
                            } else {
                                selectedCategory = stat
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusExtraLarge) { Color.clear }
        )
    }
}
