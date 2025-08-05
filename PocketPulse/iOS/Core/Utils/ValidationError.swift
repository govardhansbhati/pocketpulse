//
//  ValidationError.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 05/08/25.
//


import Foundation
import SwiftUI

// MARK: - Reusable Alert Information
/// A simple struct to hold the necessary information for presenting a SwiftUI alert.
/// This makes the alert presentation logic in the views cleaner and more consistent.
struct AlertInfo: Identifiable {
    let id = UUID()
    var title: String = "Validation Error"
    var message: String
    var primaryButton: Alert.Button = .default(Text("OK"))
}


// MARK: - Validation Error Enum
/// A custom error type that represents various validation failures throughout the app.
///
/// Conforming to `LocalizedError` allows us to provide user-friendly, descriptive
/// messages for each validation case, which can be directly displayed in alerts.
enum ValidationError: LocalizedError, Identifiable {
    
    // Conforming to Identifiable to use with .alert(item:)
    var id: String { self.localizedDescription }
    
    // MARK: - Transaction Errors
    /// Used when a required title or name field is empty.
    case missingTitle(field: String)
    
    /// Used when an amount is not a valid number or is zero/negative.
    case invalidAmount
    
    /// Used when a transaction requires an account but none is selected.
    case missingAccount
    
    // MARK: - Card Errors
    /// Used when the card number is too short or contains invalid characters.
    case invalidCardNumber
    
    /// Used when credit card-specific details (like limit or billing date) are invalid.
    case invalidCreditCardDetails(field: String)
    
    /// Used when a debit card requires a linked bank account but none is selected.
    case missingLinkedAccount
    
    // MARK: - General Errors
    /// A generic case for other validation failures.
    case custom(message: String)
    
    // MARK: - User-Facing Error Descriptions
    /// Provides a clean, user-friendly message for each error case.
    /// This is automatically used when the error is displayed in an alert.
    var errorDescription: String? {
        switch self {
        case .missingTitle(let field):
            return "Please enter a valid \(field)."
        case .invalidAmount:
            return "Please enter a valid, positive amount."
        case .missingAccount:
            return "Please select an account for this transaction."
        case .invalidCardNumber:
            return "Please enter a valid card number."
        case .invalidCreditCardDetails(let field):
            return "Please enter valid \(field) for your credit card."
        case .missingLinkedAccount:
            return "Please select a bank account to link to this debit card."
        case .custom(let message):
            return message
        }
    }
    
    // MARK: - Alert Presentation
    /// A computed property that returns an `AlertInfo` object.
    /// This can be used directly with the `.alert(item:)` modifier in SwiftUI.
    var alert: AlertInfo {
        AlertInfo(message: self.localizedDescription)
    }
}
