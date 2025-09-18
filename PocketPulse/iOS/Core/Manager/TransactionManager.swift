//
//  TransactionManager.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 24/08/25.
//

import SwiftUI
import SwiftData

// MARK:- Transaction Manager
/// A class responsible for handling all business logic related to transactions.
///
/// This centralized manager ensures that actions like deleting a transaction are handled
/// consistently across the entire application.
class TransactionManager {
    
    /// Deletes a transaction and correctly updates the balance of any linked account or card.
    /// This method is static so it can be called from anywhere without needing an instance of the manager.
    /// - Parameters:
    ///   - transaction: The `TransactionModel` object to be deleted.
    ///   - context: The SwiftData `ModelContext` to perform the deletion in.
    static func delete(transaction: TransactionModel, in context: ModelContext) {
        // Check if the transaction is linked to a bank account.
        if let accountID = transaction.linkedAccountID {
            // Find the specific account in the database.
            if let account = findAccount(with: accountID, in: context) {
                if transaction.type == .expense {
                    account.balance += transaction.amount // Add the amount back for an expense.
                } else {
                    account.balance -= transaction.amount // Subtract the amount for an income.
                }
            }
            // Check if the transaction is linked to a card.
        } else if let cardID = transaction.linkedCardID {
            // Find the specific card in the database.
            if let card = findCard(with: cardID, in: context) {
                // For a credit card expense, subtract the amount from the outstanding balance.
                card.outstandingBalance = (card.outstandingBalance ?? 0) - transaction.amount
            }
        }
        
        // After updating any linked balances, delete the transaction itself.
        context.delete(transaction)
    }
    
    // MARK: - Private Helper Functions
    
    /// Fetches an `AccountModel` with a specific ID from the database.
    private static func findAccount(with id: UUID, in context: ModelContext) -> AccountModel? {
        let predicate = #Predicate<AccountModel> { $0.id == id }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first
    }
    
    /// Fetches a `CardModel` with a specific ID from the database.
    private static func findCard(with id: UUID, in context: ModelContext) -> CardModel? {
        let predicate = #Predicate<CardModel> { $0.id == id }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first
    }
}
