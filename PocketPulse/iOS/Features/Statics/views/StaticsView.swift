//
//  Statics.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import Charts

struct StaticsView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedFilter: TimeFilter = .thisWeek
    @State private var selectedTab: StatTab = .transaction

    @StateObject private var txnVM = TransactionStatsViewModel()
    @StateObject private var analyticsVM = AnalyticsStatsViewModel()

    @State private var showDatePicker = false
    @State private var customStart = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var customEnd = Date()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Tracker").font(.title.bold())
                    Spacer()
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(TimeFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedFilter) {
                        if selectedFilter == .custom {
                            showDatePicker = true
                        } else {
                            txnVM.loadData(context: context, filter: selectedFilter)
                        }
                    }
                }
                
                Picker("Select Stat", selection: $selectedTab) {
                    ForEach(StatTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Divider()
                
                if selectedTab == .transaction {
                    HStack(spacing: 16) {
                        StatCard(title: "Income", amount: txnVM.incomeAmount, color: .green)
                        StatCard(title: "Expense", amount: txnVM.expenseAmount, color: .red)
                    }
                    
                    Chart {
                        ForEach(txnVM.incomeData) { item in
                            LineMark(x: .value("Date", item.date), y: .value("Amount", item.amount))
                                .foregroundStyle(.green)
                        }
                        ForEach(txnVM.expenseData) { item in
                            LineMark(x: .value("Date", item.date), y: .value("Amount", item.amount))
                                .foregroundStyle(.red)
                        }
                    }
                    .frame(height: 200)
                    
                    List(txnVM.filteredTransactions) { tx in
                        TransactionRow(transaction: tx)
                    }
                    .listStyle(.plain)
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Expenses by Category").font(.headline)
                        AnalyticsPieChartView(expenses: analyticsVM.categoryStats.map {
                            ExpenseCategoryStat(name: $0.name, amount: $0.amount, color: $0.color)
                        })
                        Text("Accounts by Amount").font(.headline)
                        AnalyticsPieChartView(expenses: analyticsVM.accountStats.map {
                            ExpenseCategoryStat(name: $0.name, amount: $0.amount, color: $0.color)
                        })
                    }
                }
            }
            .sheet(isPresented: $showDatePicker) {
                CustomDatePickerView(startDate: $customStart, endDate: $customEnd) {
                    txnVM.customStartDate = customStart
                    txnVM.customEndDate = customEnd
                    txnVM.loadData(context: context, filter: .custom)
                }
            }
            .padding()
            .onAppear {
                txnVM.loadData(context: context, filter: selectedFilter)
                analyticsVM.loadData(context: context)
            }
        }
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
            Text(amount, format: .currency(code: "INR"))
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

struct AnalyticsPieChartView: View {
    let expenses: [ExpenseCategoryStat]
    
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
