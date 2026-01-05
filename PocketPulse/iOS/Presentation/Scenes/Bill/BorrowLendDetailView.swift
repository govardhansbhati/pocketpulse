//
//  BorrowLendDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//
import SwiftUI

/// A view that shows more details about a specific borrow/lend item.
struct BorrowLendDetailView: View {
    @Environment(\.presentBillSheet) private var presentSheet
    let item: BorrowLendModel
    
    var body: some View {
        List {
            Section(AppStrings.Bill.detailsSection) {
                HStack { Text(AppStrings.Bill.amountLabel); Spacer(); Text(item.amount, format: .currency(code: AppConstants.Currency.isoCode)) }
                HStack { Text(AppStrings.Bill.typeLabel); Spacer(); Text(item.type.rawValue) }
                if let contact = item.contact, !contact.isEmpty {
                    HStack { Text(AppStrings.Bill.contactLabel); Spacer(); Text(contact) }
                }
                HStack { Text(AppStrings.Bill.statusLabel); Spacer(); Text(item.isSettled ? AppStrings.Bill.statusSettled : AppStrings.Bill.statusPending) }
            }
        }
        .navigationTitle(item.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(AppStrings.Bill.editAction) {
                    presentSheet?(.addBorrowLend(item: item))
                }
            }
        }
    }
}
