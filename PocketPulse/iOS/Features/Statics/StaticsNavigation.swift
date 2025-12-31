//
//  StaticsRoute.swift
//  PocketPulse
//
//  Created by govardhan singh on 19/03/25.
//


import SwiftUI
import UIKit

enum StaticsRoute {
    case transaction
    case analytics
    // TODO: need to update later
    @ViewBuilder
    var destination: some View {
        switch self {
        case .transaction:
            TransactionListView()
        case .analytics:
            //TODO:  update in future
            TransactionListView()
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
                    route.destination
                }
        }
        .environment(\.navigateStatics, NavigateAction<StaticsRoute> { homeRoute in
            routes.append(homeRoute)
        })
    }
}
