//
//  AppConfiguration.swift
//  PocketPulse
//
//  Created by Govardhan Singh on 18/01/26.
//

import Foundation

struct AppConfiguration {
    
    /// Defines the possible running environments for the application.
    enum AppEnvironment {
        case debug       // Development/Xcode
        case production  // App Store/TestFlight
        case demo        // Mock Data Mode
    }
    
    /// Determines the current environment based on build flags and launch arguments.
    static var currentEnvironment: AppEnvironment {
        if isDemoModeEnabled {
            return .demo
        }
        
        #if DEBUG
        return .debug
        #else
        return .production
        #endif
    }
    
    /// Checks if the app was launched with the "-demoMode" argument.
    static var isDemoModeEnabled: Bool {
        CommandLine.arguments.contains("-demoMode")
    }
}
