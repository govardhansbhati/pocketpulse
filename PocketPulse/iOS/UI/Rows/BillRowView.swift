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
            Text(bill.amount, format: .currency(code: AppConstants.Currency.isoCode))
        }
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                .fill(Color(.systemBackground))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                        .stroke(Color.gray.opacity(0.2), lineWidth: AppConstants.Layout.borderWidth)
                })
                .shadow(color: Color.black.opacity(0.05), radius: AppConstants.Layout.shadowRadius, x: 0, y: AppConstants.Layout.shadowY)
        )
    }
}
