//
//  PocketPulseApp.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/12/24.
//
import SwiftUI


/// The main entry point for the PocketPulse application.
///
/// The `@main` attribute identifies this struct as the starting point for the app's execution.
@main
struct PocketPulseApp: App {
    
    // MARK: - State Properties
    
    /// A state variable that controls the transition from the splash screen to the main tab view.
    /// When `false`, the `SplashView` is shown. When `true`, the `TabV` is shown.
    @State private var navigateToTab: Bool = false
    
    @State private var userProfile = UserProfile()
    
    // MARK: - State for Passcode Lock
    /// Reads the "isPasscodeEnabled" value directly from UserDefaults.
    /// This property wrapper ensures the app always knows if the passcode feature is on.
    @AppStorage("isPasscodeEnabled") private var isPasscodeEnabled: Bool = false
    
    /// A state variable that controls whether the lock screen is currently being shown.
    @State private var isLocked: Bool = false
    
    init() {
        // As soon as the app launches, request permission from the user
        // to send local notifications for reminders. This is the ideal place
        // to handle one-time setup tasks for the entire application.
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            // The Group container allows for applying modifiers to the view hierarchy
            ZStack {
                Group {
                    // Conditional logic to determine which view to display.
                    if navigateToTab && !isLocked {
                        // If true, show the main tab view with a transition from the right.
                        TabV()
                            .transition(.move(edge: .trailing))
                    } else {
                        // If false, show the splash screen with a transition from the left.
                        // The SplashView receives a binding to `navigateToTab` so it can
                        // update the state and trigger the navigation when its animation is complete.
                        SplashView(navigateToTab: $navigateToTab)
                            .transition(.move(edge: .leading))
                    }
                }
                // Apply a smooth animation to the transition between the splash screen and the tab view.
                .animation(.easeInOut(duration: 0.5), value: (navigateToTab && !isLocked))
                
                
                // --- Passcode Lock Overlay ---
                // If the app is in a locked state, this view is presented on top of everything.
                if isLocked && navigateToTab {
                    PasscodeLockView(isLocked: $isLocked)
                }
            }
            .onAppear {
                // When the app's main view appears, check if the passcode feature is enabled.
                // If it is, set the `isLocked` state to true to present the lock screen.
                if isPasscodeEnabled {
                    isLocked = true
                }
            }
            // The .modelContainer modifier is crucial for SwiftData.
            // It sets up the persistent storage and makes the ModelContext available
            // to all child views in the environment, allowing them to use @Query.
            .modelContainer(for: [
                AccountModel.self,
                CardModel.self,
                TransactionModel.self,
                BorrowLendModel.self,
                BillModel.self
            ])
            .environment(userProfile)
        }
    }
}
