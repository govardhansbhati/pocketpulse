//
//  WalletNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//

import SwiftUI

// MARK: - Wallet Navigation Stack
// This view wraps WalletView and provides navigation and sheet presentation capabilities.
struct WalletNavigationStack: View {
    @State private var path = NavigationPath()
    @State private var presentingSheet: WalletRoute.Sheet?

    var body: some View {
        NavigationStack(path: $path) {
            WalletView() // WalletView is the root of this stack
                .navigationDestination(for: WalletRoute.self) { route in
                    route.destination
                }
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
