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
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(item.type == .lent ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: item.type == .lent ? "arrow.up.right" : "arrow.down.left")
                    .foregroundColor(item.type == .lent ? .green : .red)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.adaptiveText)
                Text(item.type.rawValue)
                    .font(.caption)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
            }
            Spacer()
            Text(item.amount, format: .currency(code: AppConstants.Currency.isoCode))
                .foregroundColor(item.type == .lent ? .green : .red)
                .fontWeight(.bold)
        }
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                Color.clear
            }
        )
    }
}
