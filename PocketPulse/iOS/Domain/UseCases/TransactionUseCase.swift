//
//  TransactionUseCase.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation
import SwiftData

protocol TransactionUseCaseProtocol {
    func add(transaction: TransactionModel) async throws
    func update(transaction: TransactionModel) async throws
    func delete(transaction: TransactionModel) async throws
}

final class TransactionUseCase: TransactionUseCaseProtocol {
    private let service: TransactionsServiceProtocol
    private let accountService: AccountsServiceProtocol
    private let cardService: CardsServiceProtocol
    
    init(
        service: TransactionsServiceProtocol,
        accountService: AccountsServiceProtocol,
        cardService: CardsServiceProtocol
    ) {
        self.service = service
        self.accountService = accountService
        self.cardService = cardService
    }
    
    func add(transaction: TransactionModel) async throws {
        try await service.add(transaction)
        try await manageBalance(for: transaction, isReversal: false)
    }
    
    func update(transaction: TransactionModel) async throws {
        // Complex because we need previous state to revert before applying new state.
        try await service.update(transaction)
    }
    
    func delete(transaction: TransactionModel) async throws {
        try await manageBalance(for: transaction, isReversal: true)
        try await service.delete(transaction)
    }
    
    private func manageBalance(for transaction: TransactionModel, isReversal: Bool) async throws {
        let amount = isReversal ? -transaction.amount : transaction.amount
        
        // Handle Account Balance
        if let accountID = transaction.linkedAccountID {
            if let account = try await accountService.fetchAccount(id: accountID) {
                if transaction.type == .income {
                    account.balance += amount
                } else {
                    account.balance -= amount
                }
                try await accountService.update(account)
            }
        }
        
        // Handle Credit Card Balance
        if let cardID = transaction.linkedCardID {
            if let card = try await cardService.fetchCard(id: cardID) {
                // Determine if this is a credit card
                if card.cardType == .credit {
                    // Expense increases outstanding balance
                    // Income (Payment) decreases outstanding balance
                    if transaction.type == .expense {
                         card.outstandingBalance = (card.outstandingBalance ?? 0) + amount
                    } else {
                         card.outstandingBalance = (card.outstandingBalance ?? 0) - amount
                    }
                    try await cardService.update(card)
                }
            }
        }
    }
}
