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
    
    @Environment(\.presentBillSheet) private var presentSheet
    
    @State private var selectedTab: BillSection = .bills
    
    var body: some View {
        VStack {
            HStack {
                Text("Reminders")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
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
        // 2. When the view appears or any of the data queries change, update the ViewModel.
        .onAppear(perform: updateViewModel)
        .onChange(of: manualBills) { updateViewModel() }
        .onChange(of: cards) { updateViewModel() }
        .onChange(of: borrowLendItems) { updateViewModel() }
    }
    
    @ViewBuilder
    private var billList: some View {
        VStack {
            headerView(for: .bills)
            if viewModel.combinedBills.isEmpty {
                VStack {
                    Spacer()
                    PlaceholderView(
                        imageName: "doc.text.magnifyingglass",
                        title: "No Upcoming Bills",
                        subtitle: "Manually added bills and credit card payments will appear here.",
                        buttonLabel: "Add a Manual Bill"
                    ) {  presentSheet?(.addBill) }
                        .padding()
                    Spacer()
                }
                
            } else {
                List {
                    ForEach(viewModel.combinedBills) { bill in
                        BillRowView(bill: bill)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
    
    @ViewBuilder
    private var borrowLendList: some View {
        VStack {
            headerView(for: .borrowLend)
            if viewModel.borrowLendItems.isEmpty {
                VStack {
                    Spacer()
                    PlaceholderView(
                        imageName: "person.2.slash",
                        title: "No Entries",
                        subtitle: "Track money you've borrowed from or lent to others.",
                        buttonLabel: "Add Your First Entry"
                    ) { presentSheet?(.addBorrowLend) }
                        .padding()
                    Spacer()
                }
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
    
    @ViewBuilder
    private func headerView(for section: BillSection) -> some View {
        HStack {
            Text(section == .bills ? "Upcoming Bills" : "Borrowed & Lent")
                .font(.headline)
            Spacer()
            Button(action: {
                if section == .bills {
                    presentSheet?(.addBill)
                } else {
                    presentSheet?(.addBorrowLend)
                }
            }) {
                Label(section == .bills ? "Add Bill" : "Add Entry", systemImage: "plus")
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    // A helper function to avoid repeating the update call.
    private func updateViewModel() {
        viewModel.update(manualBills: manualBills, cards: cards, borrowLendItems: borrowLendItems)
    }
}
