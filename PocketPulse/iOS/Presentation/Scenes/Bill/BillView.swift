//
//  Bill.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import SwiftData

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
             _viewModel = StateObject(wrappedValue: BillViewModel(useCase: MockBillUseCase()))
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Header: Large title for the screen
            HStack {
                Text(AppStrings.Bill.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // Segmented Picker to switch between sections
            Picker(AppStrings.Bill.sectionPickerLabel, selection: $selectedTab) {
                ForEach(BillSection.allCases) { section in
                    Text(section.localized).tag(section)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Content: Displays the appropriate list based on the selected tab
            if selectedTab == .bills {
                billList
            } else {
                borrowLendList
            }
        }
        .task {
            await viewModel.load()
        }
        // Generic deletion alert that is triggered when `itemToDelete` is set
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
        // Reload when sheets might have dismissed or view appeared
        .onAppear {
            Task { await viewModel.load() }
        }
    }
    
    // MARK: - Subviews
    
    /// The view for displaying the list of upcoming bills.
    @ViewBuilder
    private var billList: some View {
        // Using a List is the correct way to handle dynamic content with swipe actions.
        List {
            // The header is now a section within the list for proper layout.
            Section {
                headerView(for: .bills)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            if viewModel.combinedBills.isEmpty {
                PlaceholderView(
                    imageName: "doc.text.magnifyingglass",
                    title: AppStrings.Bill.noBillsTitle,
                    subtitle: AppStrings.Bill.noBillsSubtitle,
                    buttonLabel: AppStrings.Bill.addManualButton
                ) { presentSheet?(.addBill(bill: nil)) }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 80, leading: 16, bottom: 0, trailing: 16))
            } else {
                ForEach(viewModel.combinedBills) { bill in
                    Button(action: { navigate?(.billDetail(bill)) }) {
                        BillRowView(bill: bill)
                    }
                    .buttonStyle(.plain)
                    .swipeActions {
                        Button(role: .destructive) {
                            itemToDelete = bill
                            deleteItemType = .bill(title: bill.title)
                        } label: {
                            Label(AppStrings.Common.delete, systemImage: "trash")
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.load()
        }
    }
    
    /// The view for displaying the list of borrowed and lent items.
    @ViewBuilder
    private var borrowLendList: some View {
        List {
            Section {
                headerView(for: .borrowLend)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            if viewModel.borrowLendItems.isEmpty {
                PlaceholderView(
                    imageName: "person.2.slash",
                    title: AppStrings.Bill.noEntriesTitle,
                    subtitle: AppStrings.Bill.noEntriesSubtitle,
                    buttonLabel: AppStrings.Bill.addFirstEntryButton
                ) { presentSheet?(.addBorrowLend(item: nil)) }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 80, leading: 16, bottom: 0, trailing: 16))
            } else {
                ForEach(viewModel.borrowLendItems) { item in
                    Button(action: { navigate?(.borrowLendDetail(item)) }) {
                        BorrowLendRowView(item: item)
                    }
                    .buttonStyle(.plain)
                    .swipeActions {
                        Button(role: .destructive) {
                            itemToDelete = item
                            deleteItemType = .borrowLend(name: item.name)
                        } label: {
                            Label(AppStrings.Common.delete, systemImage: "trash")
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.load()
        }
    }
    
    /// A reusable header view for each list section.
    @ViewBuilder
    private func headerView(for section: BillSection) -> some View {
        HStack {
            Text(section == .bills ? AppStrings.Bill.upcomingHeader : AppStrings.Bill.borrowLendHeader)
                .font(.headline)
            Spacer()
            Button(action: {
                if section == .bills {
                    presentSheet?(.addBill(bill: nil))
                } else {
                    presentSheet?(.addBorrowLend(item: nil))
                }
            }) {
                Label(section == .bills ? AppStrings.Bill.addBillButton : AppStrings.Bill.addEntryButton, systemImage: "plus")
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
