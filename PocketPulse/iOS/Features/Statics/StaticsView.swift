import SwiftUI
import Charts

struct StaticsView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = StaticsViewModel()
    
    @State private var selectedFilter: TimeFilter = .thisWeek
    @State private var showDatePicker = false
    
    // Date range for the custom filter
    @State private var customStartDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var customEndDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: Header and Filter
                HStack {
                    Text("Statistics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    filterMenu
                }
                
                // MARK: Summary Cards
                HStack(spacing: 16) {
                    StatCard(title: "Income", amount: viewModel.totalIncome, color: .green)
                    StatCard(title: "Expense", amount: viewModel.totalExpense, color: .red)
                }
                
                // MARK: Bar Chart
                if viewModel.graphData.isEmpty {
                    PlaceholderView(
                        imageName: "chart.bar.xaxis",
                        title: "No Data Available",
                        subtitle: "Transactions for this period will be shown here.",
                        buttonLabel: "Add a Transaction"
                    ) {}
                } else {
                    dailyTotalsChart
                }
                
                // MARK: Spending by Category (Pie Chart)
                if !viewModel.categoryStats.isEmpty {
                    spendingByCategorySection
                }
                
                // MARK: Transaction List
                transactionListSection
            }
            .padding()
        }
        .onAppear {
            viewModel.loadData(context: context, filter: selectedFilter, startDate: customStartDate, endDate: customEndDate)
        }
        .onChange(of: selectedFilter) {
            if selectedFilter == .custom {
                showDatePicker = true
            } else {
                viewModel.loadData(context: context, filter: selectedFilter, startDate: customStartDate, endDate: customEndDate)
            }
        }
        .sheet(isPresented: $showDatePicker) {
            CustomDatePickerView(startDate: $customStartDate, endDate: $customEndDate) {
                viewModel.loadData(context: context, filter: .custom, startDate: customStartDate, endDate: customEndDate)
            }
        }
    }
    
    // MARK: - Subviews
    private var filterMenu: some View {
        Picker("Filter", selection: $selectedFilter) {
            ForEach(TimeFilter.allCases) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.menu)
        .padding(.horizontal, 10)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
    
    private var dailyTotalsChart: some View {
        VStack(alignment: .leading) {
            Text("Daily Totals")
                .font(.headline)
            
            Chart(viewModel.graphData) { dataPoint in
                BarMark(
                    x: .value("Date", dataPoint.date, unit: .day),
                    y: .value("Amount", dataPoint.amount)
                )
                .foregroundStyle(dataPoint.type == .income ? Color.green.gradient : Color.red.gradient)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                }
            }
            .frame(height: 250)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
    }
    
    private var spendingByCategorySection: some View {
        VStack(alignment: .leading) {
            Text("Spending by Category")
                .font(.headline)
            AnalyticsPieChartView(expenses: viewModel.categoryStats)
        }
    }
    
    private var transactionListSection: some View {
        VStack(alignment: .leading) {
            Text("Transactions")
                .font(.headline)
            
            if viewModel.filteredTransactions.isEmpty {
                Text("No transactions in this period.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                // We use a VStack here instead of a List to avoid nested scrolling issues.
                VStack(spacing: 8) {
                    ForEach(viewModel.filteredTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
        }
    }
}

#Preview {
    StaticsView()
}

