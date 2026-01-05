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
        HStack(spacing: 12) {
            // Icon Placeholder
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 40, height: 40)
                IconView(icon: AppAssets.Icons.docTextFill, size: 18, color: .orange)
            }
            
            VStack(alignment: .leading) {
                Text(bill.title)
                    .font(.headline)
                    .foregroundColor(AppTheme.adaptiveText)
                Text("Due: \(bill.dueDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(bill.amount, format: .currency(code: AppConstants.Currency.isoCode))
                    .foregroundColor(AppTheme.adaptiveText)
                    .fontWeight(.bold)
                
                if bill.isPaid {
                    Text("PAID")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(4)
                }
            }
        }
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                Color.clear
            }
        )
    }
}
