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
            Text(item.amount, format: .currency(code: AppConstants.Currency.isoCode))
                .foregroundColor(item.type == .lent ? .red : .green)
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
