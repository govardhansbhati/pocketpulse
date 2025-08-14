//
//  WalletNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//

import SwiftUI

// MARK: - Wallet Navigation Stack
struct WalletNavigationStack: View {
    @State private var path = NavigationPath()
    @State private var presentingSheet: WalletRoute.Sheet?

    var body: some View {
        NavigationStack(path: $path) {
            WalletView() // WalletView is the root of this stack
                .navigationDestination(for: WalletRoute.self) { route in
                    route.destination
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $presentingSheet) { sheet in
            switch sheet {
            case .addCard:
                AddCardSheet(onSave: {})
            case .addAccount:
                AddAccountSheet(onSave: {})
            }
        }
        // Provide the navigation and sheet actions to the environment
        .environment(\.navigateWallet, NavigateAction { route in
            path.append(route)
        })
        .environment(\.presentWalletSheet, PresentSheetAction { sheet in
             presentingSheet = sheet
        })
    }
}

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
