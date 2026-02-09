//
//  AppError.swift
//  PocketPulse
//
//  Created by govardhan singh on 05/01/26.
//

import Foundation

/// Defines possible errors during app startup and general app operations.
enum AppError: Error, LocalizedError {
    
    /// Indicates a failure related to storage or persistence (e.g., SwiftData).
    case storage(message: String)
    
    var errorDescription: String? {
        switch self {
        case .storage(let message):
            return AppStrings.Error.storageMessage(message)
        }
    }
    
    var title: String {
        return AppStrings.Error.appErrorTitle
    }
}
