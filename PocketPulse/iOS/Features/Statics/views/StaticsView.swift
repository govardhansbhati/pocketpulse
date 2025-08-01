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

#Preview {
    StaticsView()
}

