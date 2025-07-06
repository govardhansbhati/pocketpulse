//
//  WalletTab.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//


import SwiftUI

// MARK: - Models

enum WalletTab: String, CaseIterable, Identifiable {
    case cards = "Cards"
    case accounts = "Accounts"
    
    var id: String { self.rawValue }
}

struct BankAccount: Identifiable {
    let id = UUID()
    let accountName: String
    let accountType: String // "Savings", "Current"
    let amount: Double
    let details: String
}
