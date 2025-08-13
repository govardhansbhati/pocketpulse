//
//  Bill.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI
import SwiftData

// Enum for the segmented picker in the main BillView
enum BillSection: String, CaseIterable, Identifiable {
    case bills = "Bills"
    case borrowLend = "Borrowed/Lent"
    var id: String { self.rawValue }
}

struct BillView: View {
    @StateObject private var viewModel = BillViewModel()
    
    @Query(sort: \BillModel.dueDate) private var manualBills: [BillModel]
    @Query private var cards: [CardModel]
    @Query(sort: \BorrowLendModel.name) private var borrowLendItems: [BorrowLendModel]
    
    @State private var selectedTab: BillSection = .bills
    @State private var showAddBillSheet = false
    @State private var showAddBorrowLendSheet = false

    var body: some View {
        VStack {
            Picker("Section", selection: $selectedTab) {
                ForEach(BillSection.allCases) { section in
                    Text(section.rawValue).tag(section)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if selectedTab == .bills {
                billList
            } else {
                borrowLendList
            }
        }
        .navigationTitle("Reminders")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    if selectedTab == .bills {
                        showAddBillSheet = true
                    } else {
                        showAddBorrowLendSheet = true
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }
        }
        .sheet(isPresented: $showAddBillSheet) { AddBillSheet() }
        .sheet(isPresented: $showAddBorrowLendSheet) { AddBorrowLendSheet() }
        // 2. When the view appears or any of the data queries change, update the ViewModel.
        .onAppear(perform: updateViewModel)
        .onChange(of: manualBills) { updateViewModel() }
        .onChange(of: cards) { updateViewModel() }
        .onChange(of: borrowLendItems) { updateViewModel() }
    }
    
    // The subviews now read directly from the ViewModel's processed data.
    @ViewBuilder
    private var billList: some View {
        if viewModel.combinedBills.isEmpty {
            PlaceholderView(
                imageName: "doc.text.magnifyingglass",
                title: "No Upcoming Bills",
                subtitle: "Manually added bills and credit card payments will appear here.",
                buttonLabel: "Add a Manual Bill"
            ) { showAddBillSheet = true }
            .padding()
        } else {
            List {
                ForEach(viewModel.combinedBills) { bill in
                    BillRowView(bill: bill)
                }
            }
            .listStyle(.insetGrouped)
        }
    }
    
    @ViewBuilder
    private var borrowLendList: some View {
        if viewModel.borrowLendItems.isEmpty {
            PlaceholderView(
                imageName: "person.2.slash",
                title: "No Entries",
                subtitle: "Track money you've borrowed from or lent to others.",
                buttonLabel: "Add Your First Entry"
            ) { showAddBorrowLendSheet = true }
            .padding()
        } else {
            List {
                ForEach(viewModel.borrowLendItems) { item in
                    BorrowLendRowView(item: item)
                }
            }
            .listStyle(.insetGrouped)
        }
    }
    
    // A helper function to avoid repeating the update call.
    private func updateViewModel() {
        viewModel.update(manualBills: manualBills, cards: cards, borrowLendItems: borrowLendItems)
    }
}
