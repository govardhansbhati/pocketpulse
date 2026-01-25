//
//  AddCardViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Add/Edit Card ViewModel
/// Manages the state and logic for the `AddCardSheet`.
///
/// This ViewModel handles data entry for both creating a new card and updating an existing one.
/// It includes validation logic and communicates with the SwiftData `ModelContext` to save changes.
@MainActor
class AddCardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    // These properties are bound to the UI fields in the AddCardSheet.
    
    // --- General Card Info ---
    @Published var cardHolderName: String = ""
    @Published var cardNumber: String = ""
    @Published var expiryDate: Date = .now
    @Published var providerType: CardProvider = .masterCard
    @Published var cardDesign: CardDesign = .black
    @Published var bankName: String = ""
    
    // --- Card Type ---
    @Published var cardType: CardType = .credit
    
    // --- Debit Card Specific ---
    @Published var selectedBankAccount: AccountModel?
    
    // --- Credit Card Specific ---
    @Published var creditLimit: String = ""
    @Published var outstandingBalance: String = "" // Added
    @Published var billingDate: String = ""
    @Published var paymentDueDate: String = ""
    
    // MARK: - State Management
    
    /// Holds a reference to the card being edited. This is `nil` if we are adding a new card.
    private var cardToEdit: CardModel?
    
    /// A computed property to easily check if the view is in "edit" mode.
    var isEditing: Bool { cardToEdit != nil }
    
    private let useCase: CardUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    
    init(useCase: CardUseCaseProtocol, dataUpdateService: DataUpdateServiceProtocol) {
        self.useCase = useCase
        self.dataUpdateService = dataUpdateService
    }
    
    // MARK: - Public Methods
    
    /// Populates the ViewModel's properties with data from an existing `CardModel`.
    /// This is called when the `AddCardSheet` appears in "edit" mode.
    /// - Parameter card: The `CardModel` object to be edited.
    func setup(for card: CardModel?) {
        guard let card = card else { return }
        self.cardToEdit = card
        
        // Pre-fill all the fields from the card object
        cardHolderName = card.cardHolderName
        cardNumber = card.last4Digits // Note: Only show last 4 for editing
        bankName = card.bankName
        providerType = card.providerType
        cardDesign = card.cardDesign
        cardType = card.cardType
        selectedBankAccount = card.linkedBankAccount
        
        if let limit = card.creditLimit { creditLimit = String(describing: limit) }
        if let balance = card.outstandingBalance { outstandingBalance = String(describing: balance) } // Added
        if let billDate = card.billingDate { billingDate = String(describing: billDate) }
        if let dueDate = card.paymentDueDate { paymentDueDate = String(describing: dueDate) }
        
        // Convert the "MM/yy" string back to a Date for the DatePicker
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        if let date = formatter.date(from: card.expiryDate) {
            expiryDate = date
        }
    }
    
    /// Validates the user's input and saves the card to the database.
    /// This method handles both creating a new card and updating an existing one.
    /// - Returns: A `Result` indicating success or a specific `ValidationError`.
    func save() async -> Result<Void, ValidationError> {
        // --- Validation ---
        guard !cardHolderName.isEmpty else {
            return .failure(.missingTitle(field: "Cardholder Name"))
        }
        
        // If editing, use the existing card; otherwise, create a new one.
        let card = cardToEdit ?? CardModel(cardHolderName: "",
                                           last4Digits: "",
                                           expiryDate: "",
                                           providerType: .visa,
                                           cardType: .credit,
                                           cardDesign: .black,
                                           bankName: "",
                                           orderIndex: 0)
        
        // --- Update Common Properties ---
        card.cardHolderName = cardHolderName
        card.expiryDate = formattedDate(expiryDate)
        card.providerType = providerType
        card.cardDesign = cardDesign
        card.cardType = cardType // This is disabled in the view when editing, so it won't change.
        
        // The full card number is only required and processed when creating a new card.
        if !isEditing {
            guard cardNumber.count >= 13 && cardNumber.count <= 19 && cardNumber.allSatisfy({ $0.isNumber }) else {
                return .failure(.invalidCardNumber)
            }
            if !isValidLuhn(cardNumber) {
                return .failure(.invalidCardNumber)
            }
            card.last4Digits = String(cardNumber.suffix(4))
        }
        
        // Expiry Date Validation (Must be in future)
        // We use end of the month for expiry check logic usually, or just straight date comparison.
        // Since picker gives a Date, we just check if it's < now (ignoring time components if possible, or just simple check)
        if expiryDate < Date() {
             return .failure(.invalidDate(reason: "Expiry date cannot be in the past"))
        }

        // --- Update Type-Specific Properties ---
        if cardType == .credit {
            guard !bankName.isEmpty else { return .failure(.missingTitle(field: "Bank Name")) }
            guard let limit = Double(creditLimit),
                  limit > 0 else {
                return .failure(.invalidCreditCardDetails(field: "Credit Limit"))
            }
            let balance = Double(outstandingBalance) ?? 0.0 // Optional, default to 0
            guard let billDate = Int(billingDate), (1...31).contains(billDate) else {
                return .failure(.invalidCreditCardDetails(field: "Billing Date"))
            }
            guard let dueDate = Int(paymentDueDate), (1...31).contains(dueDate) else {
                return .failure(.invalidCreditCardDetails(field: "Payment Due Date"))
            }
            
            if billDate == dueDate {
                 return .failure(.invalidCreditCardDetails(field: "Billing & Due Date cannot be same"))
            }
            
            card.bankName = bankName
            card.creditLimit = limit
            card.outstandingBalance = balance
            card.billingDate = billDate
            card.paymentDueDate = dueDate
            card.linkedBankAccount = nil // Ensure no bank account is linked for a credit card
        } else { // Debit Card
            guard let linkedAccount = selectedBankAccount else { return .failure(.missingLinkedAccount) }
            card.bankName = linkedAccount.institution
            card.linkedBankAccount = linkedAccount
            // Nullify credit card specific fields
            card.creditLimit = nil
            card.billingDate = nil
            card.paymentDueDate = nil
        }
        
        do {
            if isEditing {
                try await useCase.update(card: card)
            } else {
                try await useCase.add(card: card)
            }
            
            // Notify update
            dataUpdateService.notifyWalletUpdated()
            
            return .success(())
        } catch {
             print("Error saving card: \(error)")
             return .success(())
        }
    }
    
    // MARK: - Private Helpers
    
    private func isValidLuhn(_ number: String) -> Bool {
        var sum = 0
        let reversedDigits = number.reversed().compactMap { Int(String($0)) }
        for (index, digit) in reversedDigits.enumerated() {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    // MARK: - Private Helpers
    
    /// Converts a `Date` object into a formatted "MM/yy" string.
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: date)
    }
}
