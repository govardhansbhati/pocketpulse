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
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                Color.clear
            }
        )
    }
}
