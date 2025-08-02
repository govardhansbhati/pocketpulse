//
//  WalletRoute.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//


import SwiftUI

enum WalletRoute: Hashable {
    // Cases for pushing views onto the stack
    case accountDetail(id: UUID) // To show details for a specific account
    case allCards

    // The destination builder for pushed views
    @ViewBuilder
    var destination: some View {
        switch self {
        case .accountDetail(let id):
            // Placeholder for a detailed account view
            Text("Details for account \(id)").navigationTitle("Account Details")
        case .allCards:
            // Placeholder for the full card list view
            Text("All Cards View").navigationTitle("All Cards")
        }
    }
    
    // Defines sheets that can be presented from the Wallet screen
    enum Sheet: String, Identifiable {
        case addCard
        case addAccount
        var id: String { self.rawValue }
    }
}
