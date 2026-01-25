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
                HStack {
                    AppText.Body(text: AppStrings.Bill.amountLabel)
                    Spacer()
                    AppText.Body(text: bill.amount.formatted(.currency(code: AppConstants.Currency.isoCode)))
                }
                HStack {
                    AppText.Body(text: AppStrings.Bill.dueDateLabel)
                    Spacer()
                    AppText.Body(text: bill.dueDate.formatted(date: .long, time: .omitted))
                }
                HStack {
                    AppText.Body(text: AppStrings.Bill.statusLabel)
                    Spacer()
                    AppText.Body(text: bill.isPaid ? AppStrings.Bill.statusPaid : AppStrings.Bill.statusUnpaid)
                }
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
