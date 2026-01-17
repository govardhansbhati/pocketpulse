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
    var primaryButton: Alert.Button = .default(Text(AppStrings.Common.ok))
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
    
    /// Used when the expense amount exceeds the credit card's limit.
    case creditLimitExceeded(cardName: String)
    
    /// Used when an account have insuffiecient fund.
    case insufficientFunds(accountName: String)
    
    // MARK: - Specific Format Errors
    case invalidDate(reason: String)
    case invalidAccountNumber(reason: String)
    case invalidIFSC(reason: String)
    
    // MARK: - General Errors
    /// A generic case for other validation failures.
    case custom(message: String)
    
    // MARK: - User-Facing Error Descriptions
    /// Provides a clean, user-friendly message for each error case.
    /// This is automatically used when the error is displayed in an alert.
    var errorDescription: String? {
        switch self {
        case .missingTitle(let field):
            return AppStrings.Error.missingField(field)
        case .invalidAmount:
            return AppStrings.Error.invalidAmount
        case .missingAccount:
            return AppStrings.Error.missingAccount
        case .invalidCardNumber:
            return AppStrings.Error.invalidCardNumber
        case .invalidCreditCardDetails(let field):
            return AppStrings.Error.invalidCreditCardDetails(field)
        case .missingLinkedAccount:
            return AppStrings.Error.missingLinkedAccount
        case .creditLimitExceeded(let cardName):
             return "The expense amount exceeds the available credit limit for \(cardName)."
        case .insufficientFunds(let accountName):
            return AppStrings.Error.insufficientFundsMessage(accountName: accountName)
        case .invalidDate(let reason):
            return reason
        case .invalidAccountNumber(let reason):
            return "Invalid Account Number: \(reason)"
        case .invalidIFSC(let reason):
            return "Invalid IFSC Code: \(reason)"
        case .custom(let message):
            return message
        }
    }
    
    // MARK: - Alert Presentation
    /// A computed property that returns an `AlertInfo` object.
    /// This can be used directly with the `.alert(item:)` modifier in SwiftUI.
    var alert: AlertInfo {
           let title: String
           switch self {
           case .insufficientFunds:
               title = AppStrings.Error.insufficientFundsTitle
           default:
               // Use a generic title for all other validation errors.
               title = AppStrings.Error.validationTitle
           }
           return AlertInfo(title: title, message: self.errorDescription ?? AppStrings.Error.unknown)
       }
}
