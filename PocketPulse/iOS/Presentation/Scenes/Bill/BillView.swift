//
//  Bill.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftData
import SwiftUI

// MARK: - Supporting Enum
/// An enum to define the sections in the BillView, used by the segmented picker.
enum BillSection: String, CaseIterable, Identifiable {
    case bills = "Bills"
    case borrowLend = "Borrowed/Lent"
    var id: String { self.rawValue }
    
    var localized: String {
        switch self {
        case .bills: return AppStrings.Bill.segmentBills
        case .borrowLend: return AppStrings.Bill.segmentBorrowLend
        }
    }
}

// MARK: - Main Bill View
/// The main view for the Bills tab, displaying lists of bills and borrow/lend items.
struct BillView: View {
    // MARK: - Properties
    @StateObject private var viewModel: BillViewModel
    
    // Environment actions for navigation and sheet presentation
    @Environment(\.navigateBill) private var navigate
    @Environment(\.presentBillSheet) private var presentSheet
    
    // State for the view
    @State private var selectedTab: BillSection = .bills
    @State private var itemToDelete: (any PersistentModel)?
    @State private var deleteItemType: DeletableItemType?
    
    // init with ViewModel
    init(viewModel: BillViewModel? = nil) {
        if let vm = viewModel {
            _viewModel = StateObject(wrappedValue: vm)
        } else {
            // Fallback for previews or direct usage without factory (though factory is preferred)
            _viewModel = StateObject(wrappedValue: BillViewModel(useCase: MockBillUseCase(),
                                                                 dataUpdateService: DataUpdateService.shared))
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    AppText.Header(text: AppStrings.Bill.title)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, AppConstants.Layout.headerTopPadding) // Keep for safe area
                .padding(.bottom, AppConstants.Layout.paddingLarge)
                
                // Segmented Picker
                Picker(AppStrings.Bill.sectionPickerLabel, selection: $selectedTab) {
                    ForEach(BillSection.allCases) { section in
                        Text(section.localized).tag(section)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, AppConstants.Layout.paddingLarge)
                
                // Scrollable Content
                ScrollView {
                    VStack(spacing: AppConstants.Layout.spacingLarge) {
                        if selectedTab == .bills {
                            billList
                        } else {
                            borrowLendList
                        }
                        
                        // Bottom spacer
                        Color.clear.frame(height: AppConstants.Layout.bottomSpacerHeight)
                    }
                    .padding(.top, AppConstants.Layout.paddingTen)
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea(edges: .top)
        }
        .task {
            await viewModel.load()
        }
        .alert(
            (deleteItemType ?? .bill(title: "")).alertTitle,
            isPresented: .constant(itemToDelete != nil),
            presenting: itemToDelete
        ) { item in
            Button(AppStrings.Common.delete, role: .destructive) {
                viewModel.delete(item)
                itemToDelete = nil
            }
            Button(AppStrings.Common.cancel, role: .cancel) { itemToDelete = nil }
        } message: { _ in
            Text((deleteItemType ?? .bill(title: "")).alertMessage)
        }
        .onAppear {
            Task { await viewModel.load() }
        }
        .refreshable {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var billList: some View {
        VStack(spacing: AppConstants.Layout.spacingStandard) {
            headerView(for: .bills)
            
            // Total Upcoming Bills Card
            if !viewModel.combinedBills.isEmpty {
                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            AppText.Subtitle(text: AppStrings.Bill.totalUpcoming,
                                             color: AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                            AppText.Header(text: viewModel.totalUpcomingBills
                                .formatted(.currency(code: AppConstants.Currency.isoCode)))
                        }
                        Spacer()
                        Image(systemName: AppAssets.Icons.docTextMagnifyingGlass)
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primaryColor.opacity(AppConstants.Opacity.high))
                    }
                    .padding(AppConstants.Layout.paddingMedium)
                }
                .padding(.horizontal)
            }
            
            if viewModel.combinedBills.isEmpty {
                PlaceholderView(
                    imageName: AppAssets.Icons.docTextMagnifyingGlass,
                    title: AppStrings.Bill.noBillsTitle,
                    subtitle: AppStrings.Bill.noBillsSubtitle,
                    buttonLabel: AppStrings.Bill.addManualButton
                ) { presentSheet?(.addBill(bill: nil)) }
                    .padding(.horizontal)
            } else {
                LazyVStack(spacing: AppConstants.Layout.spacingStandard) {
                    ForEach(viewModel.combinedBills) { bill in
                        Button(action: {
                            navigate?(.billDetail(bill))
                        }) {
                            // Ensure BillRowView is glass-ready or update it next
                            BillRowView(bill: bill)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .contextMenu {
                            Button(role: .destructive) {
                                itemToDelete = bill
                                deleteItemType = .bill(title: bill.title)
                            } label: {
                                Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var borrowLendList: some View {
        VStack(spacing: AppConstants.Layout.spacingStandard) {
            headerView(for: .borrowLend)
            
            // Net Balance Card
            if !viewModel.borrowLendItems.isEmpty {
                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            AppText.Subtitle(text: AppStrings.Bill.netBalance,
                                             color: AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                            let net = viewModel.totalLent - viewModel.totalBorrowed
                            AppText.Header(text: net.formatted(.currency(code: AppConstants.Currency.isoCode)),
                                           color: net >= 0 ? .green : .red)
                            
                            HStack(spacing: 12) {
                                Label(AppStrings.Bill.lentAmount(viewModel.totalLent
                                    .formatted(.currency(code: AppConstants.Currency.isoCode))),
                                      systemImage: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundColor(.green.opacity(AppConstants.Opacity.high))
                                Label(AppStrings.Bill.borrowedAmount(viewModel.totalBorrowed
                                    .formatted(.currency(code: AppConstants.Currency.isoCode))),
                                      systemImage: "arrow.down.left")
                                    .font(.caption)
                                    .foregroundColor(.red.opacity(AppConstants.Opacity.high))
                            }
                        }
                        Spacer()
                    }
                    .padding(AppConstants.Layout.paddingMedium)
                }
                .padding(.horizontal)
            }
            
            if viewModel.borrowLendItems.isEmpty {
                PlaceholderView(
                    imageName: AppAssets.Icons.person2Slash,
                    title: AppStrings.Bill.noEntriesTitle,
                    subtitle: AppStrings.Bill.noEntriesSubtitle,
                    buttonLabel: AppStrings.Bill.addFirstEntryButton
                ) { presentSheet?(.addBorrowLend(item: nil)) }
                    .padding(.horizontal)
            } else {
                LazyVStack(spacing: AppConstants.Layout.spacingStandard) {
                    ForEach(viewModel.borrowLendItems) { item in
                        Button(action: { navigate?(.borrowLendDetail(item)) }) {
                            // Ensure BorrowLendRowView is glass-ready
                            BorrowLendRowView(item: item)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .contextMenu {
                            Button(role: .destructive) {
                                itemToDelete = item
                                deleteItemType = .borrowLend(name: item.name)
                            } label: {
                                Label(AppStrings.Common.delete, systemImage: AppAssets.Icons.trash)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func headerView(for section: BillSection) -> some View {
        HStack {
            AppText.Title(text: section == .bills ? AppStrings.Bill.upcomingHeader : AppStrings.Bill.borrowLendHeader)
            Spacer()
            Button(action: {
                if section == .bills {
                    presentSheet?(.addBill(bill: nil))
                } else {
                    presentSheet?(.addBorrowLend(item: nil))
                }
            }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: AppConstants.Size.iconLarge, height: AppConstants.Size.iconLarge)
                        .overlay(Circle().stroke(Color.white.opacity(AppConstants.Opacity.light),
                                                 lineWidth: AppConstants.Layout.borderWidth))
                    Image(systemName: AppAssets.Icons.plus)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.adaptiveText)
                }
            }
            .opacity((section == .bills ? viewModel.combinedBills.isEmpty : viewModel.borrowLendItems.isEmpty) ? 0 : 1)
        }
        .padding(.horizontal)
    }
}
