//
//  BillRowView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI

// MARK: - Row Views
/// A view that represents a single row in the bills list.
struct BillRowView: View {
    let bill: BillModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(bill.title).font(.headline)
                Text("Due: \(bill.dueDate, style: .date)").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            Text(bill.amount, format: .currency(code: "INR"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                })
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}
