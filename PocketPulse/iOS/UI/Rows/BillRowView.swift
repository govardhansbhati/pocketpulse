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
                Text(bill.title)
                    .font(.headline)
                    .foregroundColor(AppTheme.adaptiveText)
                Text("Due: \(bill.dueDate, style: .date)")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
            }
            Spacer()
            Text(bill.amount, format: .currency(code: AppConstants.Currency.isoCode))
                .foregroundColor(AppTheme.adaptiveText)
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
