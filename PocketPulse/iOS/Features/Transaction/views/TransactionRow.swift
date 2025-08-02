//
//  TransactionCell.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI

struct TransactionRow: View {
    let transaction: TransactionModel

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
                Image(systemName: transaction.type == .expense ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                    .foregroundColor(transaction.type == .expense ? .red : .green)
                Text("\(transaction.type == .expense ? "-" : "+") ₹\(Int(transaction.amount))")
                    .foregroundColor(transaction.type == .expense ? .red : .green)
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
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 8)
    }
}


