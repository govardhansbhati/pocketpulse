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
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                Color.clear
            }
        )
    }
}
