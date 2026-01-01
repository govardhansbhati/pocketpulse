//
//  NavigationCoordinator.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftUI

/// Defines the high-level routes for the application.
enum AppRoute {
    case splash
    case auth
    case main
}

/// A coordinator that manages the root navigation state of the application.
@MainActor
final class NavigationCoordinator: ObservableObject {
    
    // MARK: - Published State
    
    /// The current route determining which root view is displayed.
    @Published var currentRoute: AppRoute = .splash
    
    // MARK: - Navigation Methods
    
    /// Navigates to the Splash screen.
    func showSplash() {
        withAnimation(.easeInOut) {
            currentRoute = .splash
        }
    }
    
    /// Navigates to the Authentication (Passcode/Biometric) screen.
    func showAuth() {
        withAnimation(.easeInOut) {
            currentRoute = .auth
        }
    }
    
    /// Navigates to the Main App (TabBar) screen.
    func showMain() {
        withAnimation(.easeInOut) {
            currentRoute = .main
        }
    }
}
