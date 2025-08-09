//
//  Bill.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI

// MARK: - Main View
struct BillView: View {
    
    @Environment(\.navigateBill) private var navigate
    
    @State private var selectedTab: BillSection = .bills
    @State private var bills: [Bill] = [
        Bill(title: "Electricity", amount: 1200, dueDate: Date()),
        Bill(title: "Internet", amount: 999, dueDate: Date().addingTimeInterval(3*86400))
    ]
    @State private var borrowLendList: [BorrowLend] = [
        BorrowLend(name: "Ravi", amount: 2000, contact: "9876543210"),
        BorrowLend(name: "Priya", amount: 1500, contact: "9123456789")
    ]
    
    // Add Sheet Toggles
    @State private var showAddBillSheet: Bool = false
    @State private var showAddBorrowLendSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Segmented Picker
            Picker("Section", selection: $selectedTab) {
                ForEach(BillSection.allCases) { section in
                    Text(section.rawValue).tag(section)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Divider()
            
            if selectedTab == .bills {
                // Bills List
                HStack {
                    Text("Your Bills")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        // Add new bill logic
                        showAddBillSheet = true
                    }) {
                        Image(systemName: "plus.circle")
                        Text("Add Bill")
                    }
                }
                
                List {
                    ForEach(bills) { bill in
                        VStack(alignment: .leading) {
                            Text(bill.title)
                                .font(.headline)
                            HStack {
                                Text(bill.amount, format: .currency(code: "INR"))
                                Spacer()
                                Text("Due: \(bill.dueDate, style: .date)")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 4)
                        .onTapGesture {
                            // Edit bill logic
                        }
                    }
                }
                .listStyle(.plain)
                
            } else {
                // Borrowed/Lent Section
                HStack {
                    Text("Friends & Family")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        // Add borrow/lend entry logic
                        showAddBorrowLendSheet = true
                    }) {
                        Image(systemName: "plus.circle")
                        Text("Add Entry")
                    }
                }
                
                List {
                    ForEach(borrowLendList) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.name)
                                .font(.headline)
                            HStack {
                                Text(entry.amount, format: .currency(code: "INR"))
                                Spacer()
                                Text("Contact: \(entry.contact)")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 4)
                        .onTapGesture {
                            // Edit entry logic
                        }
                    }
                }
                .listStyle(.plain)
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showAddBillSheet ){
            AddBillSheet { newBill in
                bills.append(newBill)
            }
        }
        .sheet(isPresented: $showAddBorrowLendSheet , content: { AddBorrowLendSheet {
            newEntry in
            borrowLendList.append(newEntry)
        } })
    }
}

#Preview {
    BillView()
}
