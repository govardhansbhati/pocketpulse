//
//  HomeNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh on 04/01/25.
//
import SwiftUI

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
            case .addCard:
                // Replace with your actual AddCardSheet
                AddCardSheet(onSave: {})
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
    
    // Defines sheets that can be presented from the Home screen
    enum Sheet: String, Identifiable {
        case addCard
        var id: String { self.rawValue }
    }
}
