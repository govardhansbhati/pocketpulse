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
    @State private var selectedTab: StatTab = .transaction
    
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
                        
                        PieChartView(entries: sampleExpenseCategories)
                            .frame(height: 200)
                        
                        Text("Accounts by Amount")
                            .font(.headline)
                        
                        PieChartView(entries: sampleAccountBalances)
                            .frame(height: 200)
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
struct PieChartEntry: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
    let color: Color
}

// MARK: - Pie Chart View (Static Circles)
struct PieChartView: View {
    let entries: [PieChartEntry]
    
    var total: Double {
        entries.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<entries.count) { index in
                    let startAngle = Angle(degrees: startAngle(for: index))
                    let endAngle = Angle(degrees: endAngle(for: index))
                    let entry = entries[index]

                    PieSlice(startAngle: startAngle, endAngle: endAngle)
                        .fill(entry.color)
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
    
    func startAngle(for index: Int) -> Double {
        let totalBefore = entries.prefix(index).map { $0.value }.reduce(0, +)
        return (totalBefore / total) * 360
    }

    func endAngle(for index: Int) -> Double {
        let totalUpTo = entries.prefix(index + 1).map { $0.value }.reduce(0, +)
        return (totalUpTo / total) * 360
    }
}

// MARK: - Pie Slice Shape
struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)

        path.addArc(center: center,
                    radius: rect.width / 2,
                    startAngle: startAngle - Angle(degrees: 90),
                    endAngle: endAngle - Angle(degrees: 90),
                    clockwise: false)

        path.closeSubpath()
        return path
    }
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

let sampleExpenseCategories: [PieChartEntry] = [
    .init(category: "Grocery", value: 6000, color: .green),
    .init(category: "Rent", value: 8000, color: .blue),
    .init(category: "Gift", value: 2000, color: .purple),
    .init(category: "Bill", value: 3000, color: .orange)
]

let sampleAccountBalances: [PieChartEntry] = [
    .init(category: "Savings", value: 40000, color: .green),
    .init(category: "Wallet", value: 15000, color: .blue),
    .init(category: "Credit", value: 7000, color: .red)
]
