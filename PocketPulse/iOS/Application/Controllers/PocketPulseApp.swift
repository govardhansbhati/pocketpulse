//
//  PocketPulseApp.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/12/24.
//

import SwiftData
import SwiftUI

/// The main entry point for the PocketPulse application.
@main
struct PocketPulseApp: App {
    
    // MARK: - Dependencies
    
    /// The central DI container.
    /// We use @State to keep it alive for the app's lifecycle.
    @State private var appDI: AppDI
    
    /// Track any simplified error during startup to show an alert (like safe mode)
    @State private var startupError: AppError?
    
    /// Defines if we are running in a memory-only fallback mode
    @State private var isInMemoryFallback: Bool = false
    
    // MARK: - Initialization
    
    init() {
        // Safe container loading
        let (container, error) = AppDI.makeSafeContainer()
        
        // Initialize AppDI with the safe container
        _appDI = State(initialValue: AppDI(container: container))
        
        // If there was an error, we store it to show the user later
        if let error = error {
            _startupError = State(initialValue: error)
            _isInMemoryFallback = State(initialValue: true)
        }
        
        // One-time setup
        NotificationManager.shared.requestAuthorization()
    }
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            AppContainerView(
                coordinator: appDI.navigationCoordinator,
                appDI: appDI
            )
            // Inject the model container environment for SwiftData
            .modelContainer(appDI.modelContainer)
            // Inject global view models
            .environment(appDI.profileViewModel)
            // Error Alert for startup issues
            .alert(
                AppStrings.Error.appErrorTitle, isPresented: Binding(
                    get: { startupError != nil },
                    set: { if !$0 { startupError = nil } }
                )
            ) {
                Button(AppStrings.Common.ok, role: .cancel) { startupError = nil }
            } message: {
                if isInMemoryFallback {
                    Text(AppStrings.Error.safeModeMessage(startupError?.errorDescription ?? AppStrings.Common.unknown))
                } else {
                    Text(startupError?.errorDescription ?? AppStrings.Error.unknownErrorTitle)
                }
            }
        }
    }
}
