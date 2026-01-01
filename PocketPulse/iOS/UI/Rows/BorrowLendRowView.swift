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
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.adaptiveText)
                Text(item.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
            }
            Spacer()
            Text(item.amount, format: .currency(code: AppConstants.Currency.isoCode))
                .foregroundColor(item.type == .lent ? AppTheme.expense : AppTheme.income) // Lent is money out (expense color), Borrow is money in (income color) - or logic dependent
                .fontWeight(.semibold)
        }
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                Color.clear
            }
        )
    }
}
