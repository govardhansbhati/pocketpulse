//
//  BillDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//

import SwiftUI

// MARK: - Detail Views
/// A view that shows more details about a specific bill.
struct BillDetailView: View {
    @Environment(\.presentBillSheet) private var presentSheet
    let bill: BillModel
    
    var body: some View {
        List {
            Section(AppStrings.Bill.detailsSection) {
                HStack { Text(AppStrings.Bill.amountLabel); Spacer(); Text(bill.amount, format: .currency(code: AppConstants.Currency.isoCode)) }
                HStack { Text(AppStrings.Bill.dueDateLabel); Spacer(); Text(bill.dueDate, style: .date) }
                HStack { Text(AppStrings.Bill.statusLabel); Spacer(); Text(bill.isPaid ? AppStrings.Bill.statusPaid : AppStrings.Bill.statusUnpaid) }
            }
        }
        .navigationTitle(bill.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(AppStrings.Bill.editAction) {
                    presentSheet?(.addBill(bill: bill))
                }
            }
        }
    }
}
