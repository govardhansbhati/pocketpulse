//
//  AppContainerView.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftData
import SwiftUI

/// The root view of the application that handles high-level navigation.
struct AppContainerView: View {
    @ObservedObject var coordinator: NavigationCoordinator
    let appDI: AppDI
    
    // State for passcode lock if needed locally, though coordinator handles the flow.
    // In this new architecture, 'auth' route IS the lock screen.
    
    var body: some View {
        ZStack {
            switch coordinator.currentRoute {
            case .splash:
                SplashView(appDI: appDI)
                    .transition(.opacity)
            case .auth:
                // We wrap PasscodeLockView to handle the "unlock" by telling coordinator to go to main
                PasscodeLockWrapper(coordinator: coordinator)
                    .transition(.move(edge: .bottom))
            case .main:
                TabV()
                    .transition(.move(edge: .trailing))
                    .ignoresSafeArea()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: coordinator.currentRoute)
    }
}

/// A wrapper to adapt the PasscodeLockView to the Coordinator pattern
struct PasscodeLockWrapper: View {
    let coordinator: NavigationCoordinator
    @State private var isLocked = true // It's always locked when this view is shown
    
    var body: some View {
        PasscodeLockView(isLocked: $isLocked)
            .onChange(of: isLocked) { _, newValue in
                if !newValue {
                    // If unlocked successfully
                    coordinator.showMain()
                }
            }
    }
}
