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

// MARK: - Main Bill View
struct BillView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = BillViewModel()
    
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
        .sheet(isPresented: $showAddBillSheet, onDismiss: {
            viewModel.fetchData(context: context)
        }) { AddBillSheet() }
        .sheet(isPresented: $showAddBorrowLendSheet, onDismiss: {
            viewModel.fetchData(context: context)
        }) { AddBorrowLendSheet() }
        .onAppear {
            viewModel.fetchData(context: context)
        }
    }
    
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
        // --- FIX: Read data from the ViewModel for consistency ---
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
}
