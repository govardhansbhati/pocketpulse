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
            
            Section("Details") {
                Text("Cardholder: \(card.cardHolderName)")
                Text("Bank: \(card.bankName)")
                if card.cardType == .credit {
                    Text("Credit Limit: \(card.creditLimit ?? 0, format: .currency(code: "INR"))")
                    Text("Outstanding: \(card.outstandingBalance ?? 0, format: .currency(code: "INR"))")
                }
            }
            // TODO: Add a list of transactions for this card here
        }
        .navigationTitle("Card Details")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    presentSheet?(.addCard(card))
                }
            }
        }
    }
}
