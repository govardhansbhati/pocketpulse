import SwiftUI
import Charts
import SwiftData

// MARK: - Statics View
/// A view that displays financial statistics, including charts and a list of transactions.
///
/// This view is fully reactive to changes in the SwiftData database and allows users
/// to filter the displayed data by different time periods.
// MARK: - Statics View
/// A view that displays financial statistics, including charts and a list of transactions.
///
/// This view is fully reactive to changes in the SwiftData database and allows users
/// to filter the displayed data by different time periods.
struct StaticsView: View {
    // MARK: - Properties
    
    /// The SwiftData model context, used for performing database operations like deletion.
    @Environment(\.modelContext) private var context
    /// The ViewModel that manages the state and business logic for this view.
    @StateObject private var viewModel: StaticsViewModel
    
    init(viewModel: StaticsViewModel? = nil) {
        if let vm = viewModel {
            _viewModel = StateObject(wrappedValue: vm)
        } else {
             // Default mostly useful for preview or if specific injection isn't needed
            _viewModel = StateObject(wrappedValue: StaticsViewModel(useCase: MockStaticsUseCase(), transactionUseCase: MockTransactionUseCase()))
        }
    }
    
    /// The currently selected time filter (e.g., "This Week").
    @State private var selectedFilter: TimeFilter = .thisWeek
    /// A flag to control the presentation of the custom date picker sheet.
    @State private var showDatePicker = false
    /// Holds the transaction that the user has swiped to delete, triggering the confirmation alert.
    @State private var transactionToDelete: TransactionModel?
    
    /// The start date for the custom filter, bound to the `CustomDatePickerView`.
    @State private var customStartDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    /// The end date for the custom filter, bound to the `CustomDatePickerView`.
    @State private var customEndDate = Date()
    
    // MARK: - Body
    var body: some View {
        List {
            // Section 1: Header and Filter (as a list row)
            HStack {
                Text(AppStrings.Statics.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                filterMenu
            }
            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            // Section 2: Summary Cards
            Section {
                HStack(spacing: 16) {
                    StatCard(title: AppStrings.Statics.income, amount: viewModel.totalIncome, color: .green)
                    StatCard(title: AppStrings.Statics.expense, amount: viewModel.totalExpense, color: .red)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            // Section 3: Bar Chart
            
            Section {
                dailyTotalsChart
            }
            .listRowSeparator(.hidden)
            
            
            // Section 4: Spending by Category (Pie Chart)
            if !viewModel.categoryStats.isEmpty {
                Section {
                    spendingByCategorySection
                }
                .listRowSeparator(.hidden)
            }
            
            // Section 5: Transaction List
            transactionListSection
            
            
            // This ensures the last transaction is not hidden behind the custom tab bar.
            Section {
                Color.clear
                    .frame(height: 40)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .task {
            // Load initial data
             await loadData()
        }
        .sheet(isPresented: $showDatePicker){
            CustomDatePickerView(
                startDate: $customStartDate,
                endDate: $customEndDate,
                minDate: viewModel.minTransactionDate,
                maxDate: viewModel.maxTransactionDate
            ) {
                selectedFilter = .custom
                showDatePicker.toggle()
                Task { await loadData() }
            }
        }
        .deletionAlert(
            for: $transactionToDelete,
            ofType: .transaction(title: transactionToDelete?.title ?? "")
        ) { item in
            Task {
                await viewModel.deleteTransaction(item)
            }
        }
    }
    
    private func loadData() async {
        await viewModel.load(filter: selectedFilter, startDate: customStartDate, endDate: customEndDate)
    }
    
    // MARK: - Subviews
    
    /// A picker menu for selecting the time filter.
    private var filterMenu: some View {
        Menu {
            ForEach(TimeFilter.allCases) { filter in
                Button(filter.localized) {
                    if filter == .custom {
                        validateDateRange()
                        showDatePicker = true
                    } else {
                        selectedFilter = filter
                        Task { await loadData() }
                    }
                }
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "calendar.badge.clock")
                    .font(.title3)
                    .foregroundColor(.primary)
                Text(selectedFilter.localized)
            }
        }
        .pickerStyle(.menu)
        .labelStyle(.iconOnly)
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
    
    /// The bar chart displaying daily income and expense totals.
    private var dailyTotalsChart: some View {
        VStack(alignment: .leading) {
            Text(AppStrings.Statics.dailyTotals)
                .font(.headline)
            
            if viewModel.graphData.isEmpty {
                PlaceholderView(
                    imageName: "chart.bar.xaxis",
                    title: AppStrings.Statics.noDataTitle,
                    subtitle: AppStrings.Statics.noDataSubtitle
                )
            } else {
                Text(AppStrings.Statics.dailyTotals)
                    .font(.headline)
                
                Chart(viewModel.graphData) { dataPoint in
                    BarMark(
                        x: .value("Date", dataPoint.date, unit: .day),
                        y: .value("Amount", dataPoint.amount),
                        width: .fixed(20)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                (dataPoint.type == .income ? Color.green : Color.red).opacity(0.9),
                                (dataPoint.type == .income ? Color.green : Color.red).opacity(0.6),
                                .black.opacity(0.2) // bottom darker for depth
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(5)
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
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
    }
    
    /// The section displaying the pie chart for spending by category.
    private var spendingByCategorySection: some View {
        VStack(alignment: .leading) {
            Text(AppStrings.Statics.spendingByCategory)
                .font(.headline)
            AnalyticsPieChartView(expenses: viewModel.categoryStats)
        }
    }
    
    /// The section that lists the filtered transactions.
    @ViewBuilder
    private var transactionListSection: some View {
        Section(header: Text(AppStrings.Statics.transactionsHeader).font(.headline)) {
            if viewModel.filteredTransactions.isEmpty {
                Text(AppStrings.Statics.noTransactions)
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.filteredTransactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                transactionToDelete = transaction
                            } label: {
                                Label(AppStrings.Common.delete, systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listRowSeparator(.hidden)
    }
    
    // MARK: - Helper Functions
    
    /// A helper to ensure the date range is always valid
    private func validateDateRange() {
        if customStartDate > viewModel.maxTransactionDate {
            customStartDate = viewModel.maxTransactionDate
        }
        if customEndDate < customStartDate {
            customEndDate = customStartDate
        }
    }
}

#Preview {
    StaticsView()
}

