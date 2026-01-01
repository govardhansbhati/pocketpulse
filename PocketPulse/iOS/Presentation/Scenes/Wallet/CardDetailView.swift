//
//  CardDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 16/08/25.
//
import SwiftUI

// MARK: - Card Detail View (New)
struct CardDetailView: View {
    @Environment(\.presentWalletSheet) private var presentSheet
    let card: CardModel
    
    var body: some View {
        List {
            Section {
                CardView(card: card)
            }
            
            Section(AppStrings.Wallet.detailsSection) {
                Text("\(AppStrings.Wallet.cardHolderLabel): \(card.cardHolderName)")
                Text("\(AppStrings.Wallet.bankLabel): \(card.bankName)")
                if card.cardType == .credit {
                    Text("\(AppStrings.Wallet.creditLimitLabel): \(card.creditLimit ?? 0, format: .currency(code: "INR"))")
                    Text("\(AppStrings.Wallet.outstandingLabel): \(card.outstandingBalance ?? 0, format: .currency(code: "INR"))")
                }
            }
            // TODO: Add a list of transactions for this card here
        }
        .navigationTitle(AppStrings.Wallet.cardDetailsTitle)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(AppStrings.Wallet.editAction) {
                    presentSheet?(.addCard(card))
                }
            }
        }
    }
}
