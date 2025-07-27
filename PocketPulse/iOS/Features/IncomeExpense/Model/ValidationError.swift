//
//  ValidationError.swift
//  PocketPulse
//
//  Created by govardhan singh on 27/07/25.
//
import SwiftUI

enum ValidationError: LocalizedError {
    case missingTitle, invalidAmount, missingAccount
    var errorDescription: String? {
        switch self {
        case .missingTitle: return "Please enter a title for the transaction."
        case .invalidAmount: return "Please enter a valid, positive amount."
        case .missingAccount: return "Please select an account for the transaction."
        }
    }
}
