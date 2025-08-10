//
//  BillNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI
import UIKit

// MARK: - Bill Navigation
struct BillNavigationStack: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            BillView() // BillView is the root of this stack
                .navigationDestination(for: BillRoute.self) { route in
                    route.destination
                }
        }
        .environment(\.navigateBill, NavigateAction { route in
            path.append(route)
        })
    }
}


enum BillRoute: Hashable {
    case billDetail(id: UUID)
    case borrowLendDetail(id: UUID)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .billDetail(let id):
            Text("Details for bill \(id)").navigationTitle("Bill Details")
        case .borrowLendDetail(let id):
            Text("Details for item \(id)").navigationTitle("Entry Details")
        }
    }
}
