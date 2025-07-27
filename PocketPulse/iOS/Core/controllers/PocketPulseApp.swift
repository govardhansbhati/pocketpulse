//
//  PocketPulseApp.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/12/24.
//

import SwiftUI

@main
struct PocketPulseApp: App {
    @State private var routes: [Route] = []
    @State private var isSplashScreenVisible = true
    @State private var navigateToTab: Bool = false
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routes) {
                // Wallet view with Animation
                Group {
                    if navigateToTab {
                        TabV()
                            .transition(.move(edge: .trailing))
                    } else {
                        SplashView(navigateToTab: $navigateToTab)
                            .transition(.move(edge: .leading))
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    route.destination
                }
                .navigationBarHidden(true)
            }
            .modelContainer(for: [AccountModel.self, CardModel.self, TransactionModel.self])
            .animation(.easeInOut(duration: 0.5), value: navigateToTab)
            .environment(\.navigateRoute, NavigateAction<Route> { route in
                if case .tab = route {
                    // Reset the stack before navigating to TabbarView
                    routes = [.tab]
                } else {
                    routes.append(route)
                }
            })
            .onChange(of: routes.count) {
                print("Routes updated: \(routes.count)") // 🔍 Debugging
            }
        }
    }
}
