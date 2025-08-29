//
//  BorrowLendRowView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI

/// A view that represents a single row in the borrow/lend list.
struct BorrowLendRowView: View {
    let item: BorrowLendModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name).font(.headline)
                Text(item.type.rawValue).font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            Text(item.amount, format: .currency(code: "INR"))
                .foregroundColor(item.type == .lent ? .red : .green)
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
