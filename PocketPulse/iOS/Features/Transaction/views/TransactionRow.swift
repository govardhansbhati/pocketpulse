//
//  TransactionCell.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: transaction.isExpense ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                    .foregroundColor(transaction.isExpense ? .red : .green)
                Text("\(transaction.isExpense ? "-" : "+") ₹\(Int(transaction.amount))")
                    .foregroundColor(transaction.isExpense ? .red : .green)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                })
                .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 8)
    }
}

#Preview {
    TransactionRow(transaction: Transaction(title: "Grocery", amount: 24.5, date: Date(), isExpense: true))
}
