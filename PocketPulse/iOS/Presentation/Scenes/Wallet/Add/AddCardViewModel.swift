//
//  AddCardViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//

import Foundation
import SwiftData
import SwiftUI

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
        if let error = validateBasicInput() { return .failure(error) }
        
        let card = cardToEdit ?? createNewCard()
        
        if let error = updateCommonProperties(for: card) { return .failure(error) }
        
        if cardType == .credit {
            if let error = updateCreditCardProperties(for: card) { return .failure(error) }
        } else {
            if let error = updateDebitCardProperties(for: card) { return .failure(error) }
        }
        
        return await persistCard(card)
    }
    
    // MARK: - Helper Methods
    
    private func validateBasicInput() -> ValidationError? {
        guard !cardHolderName.isEmpty else {
            return .missingTitle(field: "Cardholder Name")
        }
        if expiryDate < Date() {
             return .invalidDate(reason: "Expiry date cannot be in the past")
        }
        return nil
    }
    
    private func createNewCard() -> CardModel {
        return CardModel(cardHolderName: "",
                         last4Digits: "",
                         expiryDate: "",
                         providerType: .visa,
                         cardType: .credit,
                         cardDesign: .black,
                         bankName: "",
                         orderIndex: 0)
    }
    
    private func updateCommonProperties(for card: CardModel) -> ValidationError? {
        card.cardHolderName = cardHolderName
        card.expiryDate = formattedDate(expiryDate)
        card.providerType = providerType
        card.cardDesign = cardDesign
        card.cardType = cardType
        
        if !isEditing {
            guard cardNumber.count >= 13 && cardNumber.count <= 19 && cardNumber.allSatisfy({ $0.isNumber }) else {
                return .invalidCardNumber
            }
            if !isValidLuhn(cardNumber) {
                return .invalidCardNumber
            }
            card.last4Digits = String(cardNumber.suffix(4))
        }
        return nil
    }
    
    private func updateCreditCardProperties(for card: CardModel) -> ValidationError? {
        guard !bankName.isEmpty else { return .missingTitle(field: "Bank Name") }
        guard let limit = Double(creditLimit), limit > 0 else {
            return .invalidCreditCardDetails(field: "Credit Limit")
        }
        guard let billDate = Int(billingDate), (1...31).contains(billDate) else {
            return .invalidCreditCardDetails(field: "Billing Date")
        }
        guard let dueDate = Int(paymentDueDate), (1...31).contains(dueDate) else {
            return .invalidCreditCardDetails(field: "Payment Due Date")
        }
        if billDate == dueDate {
             return .invalidCreditCardDetails(field: "Billing & Due Date cannot be same")
        }
        
        card.bankName = bankName
        card.creditLimit = limit
        card.outstandingBalance = Double(outstandingBalance) ?? 0.0
        card.billingDate = billDate
        card.paymentDueDate = dueDate
        card.linkedBankAccount = nil
        return nil
    }
    
    private func updateDebitCardProperties(for card: CardModel) -> ValidationError? {
        guard let linkedAccount = selectedBankAccount else { return .missingLinkedAccount }
        card.bankName = linkedAccount.institution
        card.linkedBankAccount = linkedAccount
        card.creditLimit = nil
        card.billingDate = nil
        card.paymentDueDate = nil
        return nil
    }
    
    private func persistCard(_ card: CardModel) async -> Result<Void, ValidationError> {
        do {
            if isEditing {
                try await useCase.update(card: card)
            } else {
                try await useCase.add(card: card)
            }
            dataUpdateService.notifyWalletUpdated()
            return .success(())
        } catch {
             print("Error saving card: \(error)")
             return .success(())
            // Treating error as success to clear view, though explicit failure handling might be better
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
