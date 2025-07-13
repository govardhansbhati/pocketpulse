//
//  Card.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import SwiftUI
import Combine

struct Card: Identifiable {
    
    enum CardProvider: String {
        case masterCard
        case masterCardLimited
    }
    
    let id = UUID()
    let cardNumber: String
    let expiryDate: String
    let cardHolderName: String
    let providerType: CardProvider
    let cardType: CardType // Debit or Credit
    var cardDesign: CardDesign
}

enum CardType {
    case debit
    case credit
}

enum CardDesign: CaseIterable, Identifiable {
    var id: Self {self}
    
    case black
    case orange
    case pink
}
