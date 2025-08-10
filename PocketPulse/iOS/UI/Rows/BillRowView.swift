//
//  BillRowView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI

// MARK: - Supporting Row Views
struct BillRowView: View {
    let bill: BillModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(bill.title).font(.headline)
                Text("Due: \(bill.dueDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(bill.amount, format: .currency(code: "INR"))
        }
    }
}
