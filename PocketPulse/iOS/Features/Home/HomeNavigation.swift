//
//  HomeNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh on 04/01/25.
//
import SwiftUI

// MARK: - Home Navigation Stack
struct HomeNavigationStack: View {
    @State private var path = NavigationPath()
    @State private var presentingSheet: HomeRoute.Sheet?

    var body: some View {
        NavigationStack(path: $path) {
            HomeView() // HomeView is the root of this stack
                .navigationDestination(for: HomeRoute.self) { route in
                    route.destination
                }
        }
        .sheet(item: $presentingSheet) { sheet in
            switch sheet {
            case .addCard(let card):
                AddCardSheet(cardToEdit: card, onSave: {})
            case .balanceBreakdown(let accounts):
                BalanceBreakdownSheet(accounts: accounts)
            }
        }
        // Provide the navigation and sheet actions to the environment
        .environment(\.navigateHome, NavigateAction { route in
            path.append(route)
        })
        .environment(\.presentSheet, PresentSheetAction { sheet in
             presentingSheet = sheet
        })
    }
}

// Environment Keys
private struct NavigateHomeKey: EnvironmentKey {
    static let defaultValue: NavigateAction<HomeRoute>? = nil
}
private struct PresentSheetKey: EnvironmentKey {
    static let defaultValue: PresentSheetAction<HomeRoute.Sheet>? = nil
}


// MARK: - Home Navigation Routes
enum HomeRoute: Hashable {
    // Cases for pushing views onto the stack
    case transactionList
    case allCards
    case profile
    case notification

    // The destination builder for pushed views
    @ViewBuilder
    var destination: some View {
        switch self {
        case .transactionList:
            TransactionListView()
        case .allCards:
            // Placeholder for the full card list view
            Text("All Cards View").navigationTitle("All Cards")
        case .profile:
            ProfileView() // Assuming you have this view
        case .notification:
            NotificationView() // Assuming you have this view
        }
    }
    
    // The Sheet enum now includes the balance breakdown case
    enum Sheet: Identifiable {
        case addCard(CardModel?)
        case balanceBreakdown([AccountModel]) // Pass the accounts to be displayed
        
        var id: String {
            switch self {
            case .addCard: return "addOrEditCard"
            case .balanceBreakdown: return "balanceBreakdown"
            }
        }
    }
}
