import SwiftUI
import Charts
import SwiftData

// MARK: - Statics View 
struct StaticsView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = StaticsViewModel()
    
    @Query(sort: \TransactionModel.date, order: .reverse) private var transactions: [TransactionModel]
    
    @State private var selectedFilter: TimeFilter = .thisWeek
    @State private var showDatePicker = false
    @State private var transactionToDelete: TransactionModel?
    
    // Date range for the custom filter
    @State private var customStartDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var customEndDate = Date()
    
    var body: some View {
        List {
            // Section 1: Header and Filter (as a list row)
            Section {
                HStack {
                    Text("Statistics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    filterMenu
                }
            }
            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            // Section 2: Summary Cards
            Section {
                HStack(spacing: 16) {
                    StatCard(title: "Income", amount: viewModel.totalIncome, color: .green)
                    StatCard(title: "Expense", amount: viewModel.totalExpense, color: .red)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            // Section 3: Bar Chart
            if viewModel.graphData.isEmpty {
                Section {
                    PlaceholderView(
                        imageName: "chart.bar.xaxis",
                        title: "No Data Available",
                        subtitle: "Transactions for this period will be shown here.",
                        buttonLabel: "Add a Transaction"
                    ) {}
                }
                .listRowSeparator(.hidden)
            } else {
                Section {
                    dailyTotalsChart
                }
                .listRowSeparator(.hidden)
            }
            
            // Section 4: Spending by Category (Pie Chart)
            if !viewModel.categoryStats.isEmpty {
                Section {
                    spendingByCategorySection
                }
                .listRowSeparator(.hidden)
            }
            
            // Section 5: Transaction List
            transactionListSection
        }
        .listStyle(.plain)
        .onAppear(perform: updateViewModel)
        
        .onChange(of: transactions) { updateViewModel() }
        .onChange(of: selectedFilter) {
            if selectedFilter == .custom {
                showDatePicker = true
            } else {
                updateViewModel()
            }
        }
        .sheet(isPresented: $showDatePicker) {
            CustomDatePickerView(
                startDate: $customStartDate,
                endDate: $customEndDate,
                minDate: viewModel.minTransactionDate,
                maxDate: viewModel.maxTransactionDate
            ) {
                updateViewModel()
            }
        }
        .deletionAlert(
            for: $transactionToDelete,
            ofType: .transaction(title: transactionToDelete?.title ?? "")
        ) { item in
            // Provide the specific deletion logic here, calling the TransactionManager.
            TransactionManager.delete(transaction: item, in: context)
        }
    }
    
    // MARK: - Subviews
    private var filterMenu: some View {
        Picker("Filter", selection: $selectedFilter) {
            ForEach(TimeFilter.allCases) { filter in
                Text(filter.rawValue).tag(filter)
                    .disabled(isDisabled(filter: filter))
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
    
    @ViewBuilder
    private var transactionListSection: some View {
        Section(header: Text("Transactions").font(.headline)) {
            if viewModel.filteredTransactions.isEmpty {
                Text("No transactions in this period.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.filteredTransactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                transactionToDelete = transaction
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listRowSeparator(.hidden)
    }
    
    private func updateViewModel() {
        viewModel.update(
            transactions: transactions,
            filter: selectedFilter,
            startDate: customStartDate,
            endDate: customEndDate
        )
    }
    
    private func isDisabled(filter: TimeFilter) -> Bool {
        switch filter {
        case .thisWeek:
            return !viewModel.isThisWeekFilterEnabled
        case .thisMonth:
            return !viewModel.isThisMonthFilterEnabled
        case .custom:
            return false // Custom is always enabled
        }
    }
}

#Preview {
    StaticsView()
}

