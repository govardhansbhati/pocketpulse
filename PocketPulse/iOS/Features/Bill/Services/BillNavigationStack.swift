//
//  BillNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI
import UIKit

enum BillRoute {
    case transaction
    case analytics
    // TODO: need to update later
    @ViewBuilder
    var destination: some View {
        switch self {
        case .transaction:
            BalanceView()
        case .analytics:
            ProfileView()
        }
    }
}


struct BillNavigationStack: View {
    @State private var routes: [BillRoute] = []
    
    var body: some View {
        NavigationStack(path: $routes) {
            BillView()
                .navigationDestination(for: BillRoute.self) { route in
                    route.destination
                }
        }
        // TODO: need to update later
        .environment(\.navigateBill, NavigateAction<BillRoute> { homeRoute in
            routes.append(homeRoute)
        })
    }
}
