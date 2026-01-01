//
//  PocketPulseApp.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/12/24.
//
import SwiftUI
import SwiftData

// Defines possible errors during app startup
enum AppError: Error, LocalizedError {
    case storage(message: String)
    
    var errorDescription: String? {
        switch self {
        case .storage(let message):
            return "Storage Error: \(message)"
        }
    }
    
    var title: String {
        return "App Error"
    }
}

/// The main entry point for the PocketPulse application.
@main
struct PocketPulseApp: App {
    
    // MARK: - Dependencies
    
    // The central DI container.
    // We use @State to keep it alive for the app's lifecycle.
    @State private var appDI: AppDI
    
    // Track any simplified error during startup to show an alert (like safe mode)
    @State private var startupError: AppError?
    
    // Defines if we are running in a memory-only fallback mode
    @State private var isInMemoryFallback: Bool = false
    
    // MARK: - Initialization
    
    init() {
        // Safe container loading
        let (container, error) = PocketPulseApp.makeSafeContainer()
        
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
                "App Error", isPresented: Binding(
                    get: { startupError != nil },
                    set: { if !$0 { startupError = nil } }
                )
            ) {
                Button("OK", role: .cancel) { startupError = nil }
            } message: {
                if isInMemoryFallback {
                    Text("The app is running in Safe Mode due to a storage error. Changes may not be saved.\n\nError: \(startupError?.errorDescription ?? "Unknown")")
                } else {
                    Text(startupError?.errorDescription ?? "Unknown Error")
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Attempts to build the persistent container, falling back to in-memory on failure.
    private static func makeSafeContainer() -> (ModelContainer, AppError?) {
        do {
            return (try AppDI.buildDefaultDBModelContainer(), nil)
        } catch {
            print("CRITICAL: Failed to load persistent store: \(error)")
            let appErr = AppError.storage(message: error.localizedDescription)
            
            // Fallback to in-memory
            if let memoryContainer = try? AppDI.buildInMemoryModelContainer() {
                return (memoryContainer, appErr)
            } else {
                // If even in-memory fails, we can't run.
                fatalError("CRITICAL: Could not create in-memory store fallback. Error: \(error)")
            }
        }
    }
}
