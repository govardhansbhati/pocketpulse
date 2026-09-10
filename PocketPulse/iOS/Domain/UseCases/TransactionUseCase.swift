//
//  TransactionUseCase.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation

protocol TransactionUseCaseProtocol {
    func add(transaction: TransactionModel) async throws
    func update(transaction: TransactionModel) async throws
    func delete(transaction: TransactionModel) async throws
    func quickAdd(detected: DetectedTransaction) async throws
}

extension TransactionUseCaseProtocol {
    func quickAdd(detected: DetectedTransaction) async throws {}
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
    
    func quickAdd(detected: DetectedTransaction) async throws {
        let accounts = try await accountService.fetchAccounts()
        let cards = try await cardService.fetchCards()
        let (matchedAccountID, matchedCardID) = resolvePaymentSource(
            hint: detected.accountHint,
            accounts: accounts,
            cards: cards
        )
        
        let newTransaction = TransactionModel(
            title: detected.title,
            amount: detected.amount,
            type: detected.type,
            category: detected.category,
            date: detected.date,
            linkedAccountID: matchedAccountID,
            linkedCardID: matchedCardID
        )
        
        try await add(transaction: newTransaction)
    }
    
    func update(transaction: TransactionModel) async throws {
        // Fetch existing transaction to revert previous balance effect before applying new state
        let existingTransactions = try await service.fetchTransactions()
        if let existing = existingTransactions.first(where: { $0.id == transaction.id }) {
            try await manageBalance(for: existing, isReversal: true)
        }
        try await service.update(transaction)
        try await manageBalance(for: transaction, isReversal: false)
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
        
        // Handle Card Balance
        if let cardID = transaction.linkedCardID {
            if let card = try await cardService.fetchCard(id: cardID) {
                if card.cardType == .credit {
                    // Expense increases outstanding balance
                    // Income (Payment) decreases outstanding balance
                    if transaction.type == .expense {
                        card.outstandingBalance = (card.outstandingBalance ?? 0) + amount
                    } else {
                        card.outstandingBalance = (card.outstandingBalance ?? 0) - amount
                    }
                    try await cardService.update(card)
                } else if card.cardType == .debit && transaction.linkedAccountID == nil {
                    // If no direct linkedAccountID was set, deduct from debit card's linked account
                    if let account = card.linkedBankAccount {
                        if transaction.type == .income {
                            account.balance += amount
                        } else {
                            account.balance -= amount
                        }
                        try await accountService.update(account)
                    }
                }
            }
        }
    }
    
    private func resolvePaymentSource(
        hint: String?,
        accounts: [AccountModel],
        cards: [CardModel]
    ) -> (accountID: UUID?, cardID: UUID?) {
        guard let hint = hint?.lowercased() else {
            return (accounts.first?.id, nil)
        }
        
        for card in cards {
            let bankMatch = hint.contains(card.bankName.lowercased())
            let lastDigitsMatch = card.last4Digits.count >= 4 && hint.contains(card.last4Digits)
            if bankMatch || lastDigitsMatch {
                return (nil, card.id)
            }
        }
        
        for account in accounts {
            let nameMatch = hint.contains(account.name.lowercased())
            let instMatch = hint.contains(account.institution.lowercased())
            let numMatch: Bool
            if let accNum = account.accountNumber, accNum.count >= 4 {
                numMatch = hint.contains(accNum.suffix(4))
            } else {
                numMatch = false
            }
            if nameMatch || instMatch || numMatch {
                return (account.id, nil)
            }
        }
        
        if let firstAccount = accounts.first {
            return (firstAccount.id, nil)
        }
        if let firstCard = cards.first {
            return (nil, firstCard.id)
        }
        return (nil, nil)
    }
}
