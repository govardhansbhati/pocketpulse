//
//  BorrowLendDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//
import SwiftUI

/// A view that shows more details about a specific borrow/lend item.
struct BorrowLendDetailView: View {
    @Environment(\.presentBillSheet) private var presentSheet
    let item: BorrowLendModel
    
    var body: some View {
        List {
            Section("Details") {
                HStack { Text("Amount"); Spacer(); Text(item.amount, format: .currency(code: "INR")) }
                HStack { Text("Type"); Spacer(); Text(item.type.rawValue) }
                if let contact = item.contact, !contact.isEmpty {
                    HStack { Text("Contact"); Spacer(); Text(contact) }
                }
                HStack { Text("Status"); Spacer(); Text(item.isSettled ? "Settled" : "Pending") }
            }
        }
        .navigationTitle(item.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    presentSheet?(.addBorrowLend(item: item))
                }
            }
        }
    }
}
