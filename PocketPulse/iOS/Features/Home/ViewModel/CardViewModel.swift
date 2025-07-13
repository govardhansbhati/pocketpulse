//
//  CardViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import SwiftUI
import Combine

@Observable
class CardViewModel {
    // MARK: Variable
    
    var cards: [Card] = [
        Card(cardNumber: "**** **** **** 1234",
             expiryDate: "12/26",
             cardHolderName: "John Doe",
             providerType: .masterCard,
             cardType: .debit,
             cardDesign: .black),
        Card(cardNumber: "**** **** **** 5678",
             expiryDate: "01/28",
             cardHolderName: "John Doe",
             providerType: .masterCard,
             cardType: .debit,
             cardDesign: .pink),
        Card(cardNumber: "**** **** **** 9876",
             expiryDate: "03/27",
             cardHolderName: "John Doe",
             providerType: .masterCard,
             cardType: .debit,
             cardDesign: .orange)
    ]
    
    let animationDuration: TimeInterval = 0.5
    
    
    // MARK: - Function
    // Function to shift the last card and insert it in the 0th index
    
    func shiftCard() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            let card = cards.removeLast()
            cards.insert(card, at: 0)
        }
    }
}
