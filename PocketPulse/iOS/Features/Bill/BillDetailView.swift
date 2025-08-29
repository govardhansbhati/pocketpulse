//
//  BillDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//

import SwiftUI

// MARK: - Detail Views
/// A view that shows more details about a specific bill.
struct BillDetailView: View {
    @Environment(\.presentBillSheet) private var presentSheet
    let bill: BillModel
    
    var body: some View {
        List {
            Section("Details") {
                HStack { Text("Amount"); Spacer(); Text(bill.amount, format: .currency(code: "INR")) }
                HStack { Text("Due Date"); Spacer(); Text(bill.dueDate, style: .date) }
                HStack { Text("Status"); Spacer(); Text(bill.isPaid ? "Paid" : "Unpaid") }
            }
        }
        .navigationTitle(bill.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    presentSheet?(.addBill(bill: bill))
                }
            }
        }
    }
}
