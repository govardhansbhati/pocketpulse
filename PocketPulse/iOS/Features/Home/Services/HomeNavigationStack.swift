//
//  HomeNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh on 04/01/25.
//
import SwiftUI

struct HomeNavigationStack: View {
    @State private var routes: [HomeRoute] = []
    
    var body: some View {
        NavigationStack(path: $routes) {
            HomeView()
                .navigationDestination(for: HomeRoute.self) { route in
                    route.destination
                }
        }.environment(\.navigate, NavigateAction(action: { route in
            if case let .home(homeRoute) = route {
                routes.append(homeRoute)
            }
        }))
    }
}
