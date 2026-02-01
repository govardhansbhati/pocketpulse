//
//  StaticsRoute.swift
//  PocketPulse
//
//  Created by govardhan singh on 04/01/25.
//

import SwiftData
import SwiftUI
import UIKit

// MARK: - Statics Navigation Routes
enum StaticsRoute: Hashable {
    case transactionList
    
    @MainActor
    @ViewBuilder
    func destination(context: ModelContext) -> some View {
        switch self {
        case .transactionList:
            TransactionFactory(context: context).makeTransactionListView()
        }
    }
}

struct StaticNavigationStack: View {
    @Environment(\.modelContext) private var context
    @State private var routes: [StaticsRoute] = []
    
    var body: some View {
        NavigationStack(path: $routes) {
            // Use the factory to create the view with dependencies injected
            StaticsFactory(context: context).makeStaticsView()
                .navigationDestination(for: StaticsRoute.self) { route in
                    route.destination(context: context)
                }
        }
        .environment(\.navigateStatics, NavigateAction<StaticsRoute> { homeRoute in
            routes.append(homeRoute)
        })
    }
}
