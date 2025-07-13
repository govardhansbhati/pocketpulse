//
//  Statics.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import Charts

struct StaticsView: View {
    @Environment(\.navigateStatics) private var navigate
    @State private var selectedFilter: TimeFilter = .thisWeek
    @State private var selectedTab: StatTab = .analytics
    
    let dummyData = [
            ExpenseCategory(name: "Food", amount: 200, color: .blue),
            ExpenseCategory(name: "Rent", amount: 800, color: .green),
            ExpenseCategory(name: "Transport", amount: 150, color: .orange),
            ExpenseCategory(name: "Entertainment", amount: 100, color: .purple)
        ]

    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Text("Tracker")
                        .font(.title.bold())
                    Spacer()
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(TimeFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                //Segment Control
            Picker("Select Stat", selection: $selectedTab) {
                ForEach(StatTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical, 8)
                
                Divider()

                if selectedTab == .transaction {
                    // Income and Expense Summary
                    HStack(spacing: 16) {
                        StatCard(title: "Income", amount: 32000, color: .green)
                        StatCard(title: "Expense", amount: 21000, color: .red)
                    }
                    
                    // Line Graph: Income and Expense vs Time
                    Chart {
                        ForEach(sampleGraphDataIncome) { item in
                            LineMark(x: .value("Date", item.date), y: .value("Amount", item.amount))
                                .foregroundStyle(Color.green)
                                .symbol(Circle())
                        }
                        
                        ForEach(sampleGraphDataExpense) { item in
                            LineMark(x: .value("Date", item.date), y: .value("Amount", item.amount))
                                .foregroundStyle(Color.blue)
//                                .symbol(<#_#>)
                        }
                    }
                    .frame(height: 200)
                } else {
                    // Analytics: Pie Charts
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Expenses by Category")
                            .font(.headline)
                        
                        AnalyticsPieChartView(expenses: dummyData)
                        
                        Text("Accounts by Amount")
                            .font(.headline)
                        
//                        PieChartView(entries: sampleAccountBalances)
//                            .frame(height: 200)
                    }
                }

                Spacer()
            }
            .padding()
        }
}

#Preview(body: {
    StaticsView()
})



enum TimeFilter: String, CaseIterable, Identifiable {
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case custom = "Custom"
    
    var id: String { self.rawValue }
}

enum StatTab: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case transaction = "Transaction Stats"
    case analytics = "Analytics Stats"
}


// MARK: - Stat Card View
struct StatCard: View {
    let title: String
    let amount: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
            Text("₹\(Int(amount))")
                .font(.title3.bold())
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Pie Chart Entry Model
struct ExpenseCategory: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}


struct GraphData: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}

let sampleGraphDataIncome: [GraphData] = [
    GraphData(date: Date().addingTimeInterval(-5*86400), amount: 8000),
    GraphData(date: Date().addingTimeInterval(-3*86400), amount: 12000),
    GraphData(date: Date(), amount: 32000)
]

let sampleGraphDataExpense: [GraphData] = [
    GraphData(date: Date().addingTimeInterval(-5*86400), amount: 3000),
    GraphData(date: Date().addingTimeInterval(-3*86400), amount: 9000),
    GraphData(date: Date(), amount: 21000)
]



struct AnalyticsPieChartView: View {
    let expenses: [ExpenseCategory]
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Expenses Breakdown")
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
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("$\(String(format: "%.2f", totalAmount))")
                        .font(.title3.bold())
                }
            )

            // Custom Legend
            VStack(alignment: .leading, spacing: 8) {
                ForEach(expenses) { item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: 12, height: 12)
                        Text(item.name)
                            .font(.subheadline)
                        Spacer()
                        Text("$\(String(format: "%.2f", item.amount))")
                            .font(.subheadline.bold())
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
