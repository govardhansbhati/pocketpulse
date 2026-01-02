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
    // MARK: - Body
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                // Header Title
                Text(AppStrings.Statics.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 60) // Safe Area
                    .padding(.bottom, AppConstants.Layout.paddingSmall)
                
                // Time Capsule Filter
                TimeCapsuleSelector(selectedFilter: $selectedFilter) { filter in
                    if filter == .custom {
                        validateDateRange()
                        showDatePicker = true
                    } else {
                        Task { await loadData() }
                    }
                }
                .padding(.bottom, AppConstants.Layout.paddingSmall)
                
                ScrollView {
                    VStack(spacing: AppConstants.Layout.spacingLarge) {
                        
                        // MARK: - Smart Summary Cards
                        HStack(spacing: AppConstants.Layout.spacingMedium) {
                            // Income
                            SummaryPill(
                                title: AppStrings.Statics.income,
                                amount: viewModel.totalIncome,
                                icon: AppAssets.Icons.arrowDown,
                                color: AppTheme.income
                            )
                            
                            // Expense
                            SummaryPill(
                                title: AppStrings.Statics.expense,
                                amount: viewModel.totalExpense,
                                icon: AppAssets.Icons.arrowUp,
                                color: AppTheme.expense
                            )
                        }
                        .padding(.horizontal)
                        
                        // Savings Rate Card
                        SavingsRateCard(income: viewModel.totalIncome, expense: viewModel.totalExpense)
                            .padding(.horizontal)
                        
                        // MARK: - Spending Trends (Line)
                        SpendingTrendsChart(data: viewModel.graphData)
                            .padding(.horizontal)
                        
                        // MARK: - Equalizer Chart (Bar)
                        EqualizerChart(data: viewModel.graphData)
                            .padding(.horizontal)
                        
                        // MARK: - Energy Ring (Categories)
                        if !viewModel.categoryStats.isEmpty {
                            EnergyRingChart(categoryStats: viewModel.categoryStats)
                                .padding(.horizontal)
                        }
                        
                        // MARK: - Recent Transactions
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingStandard) {
                            Text(AppStrings.Statics.transactionsHeader)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.horizontal)
                            
                            if viewModel.filteredTransactions.isEmpty {
                                ContentUnavailableView(
                                    AppStrings.Statics.noTransactions,
                                    systemImage: AppAssets.Icons.docTextMagnifyingGlass
                                )
                                .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                            } else {
                                LazyVStack(spacing: AppConstants.Layout.spacingMedium) {
                                    ForEach(viewModel.filteredTransactions) { transaction in
                                        TransactionRow(transaction: transaction)
                                            .padding(.horizontal)
                                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                Button(role: .destructive) {
                                                    transactionToDelete = transaction
                                                } label: {
                                                    Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        
                        // Bottom Padding
                        Color.clear.frame(height: 100)
                    }
                    .padding(.top)
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea(edges: .top)
        }
        .task {
            // Load initial data
             await loadData()
        }
        .onReceive(NotificationCenter.default.publisher(for: .transactionDataChanged)) { _ in
             Task { await loadData() }
        }
        .onReceive(NotificationCenter.default.publisher(for: .walletDataChanged)) { _ in
             Task { await loadData() }
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

// MARK: - Local Subcomponents
struct SummaryPill: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    
    var body: some View {
        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                HStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(color)
                        )
                    Text(title)
                        .font(.caption)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                }
                
                Text(amount, format: .currency(code: AppConstants.Currency.isoCode))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText)
                    .minimumScaleFactor(0.8)
            }
            .padding(AppConstants.Layout.paddingMedium)
        }
    }
}

struct SavingsRateCard: View {
    let income: Double
    let expense: Double
    
    var savingsRate: Double {
        guard income > 0 else { return 0 }
        return max(0, (income - expense) / income)
    }
    
    var body: some View {
        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusExtraLarge) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Savings Rate")
                        .font(.headline)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                    Text(savingsRate, format: .percent.precision(.fractionLength(1)))
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(savingsRate > 0.2 ? AppTheme.income : (savingsRate > 0 ? .yellow : AppTheme.expense))
                    
                    Text(savingsRate > 0.2 ? "Healthy financial habit!" : "Keep pushing to save more.")
                        .font(.caption)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.5))
                }
                
                Spacer()
                
                // Circular Progress
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: savingsRate)
                        .stroke(
                            AngularGradient(colors: [AppTheme.income, .teal], center: .center),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .shadow(color: AppTheme.income.opacity(0.5), radius: 10)
                }
                .frame(width: 60, height: 60)
            }
            .padding(AppConstants.Layout.paddingLarge)
        }
    }
}

#Preview {
    StaticsView()
}

