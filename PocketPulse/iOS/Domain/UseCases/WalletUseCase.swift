//
//  WalletUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import Foundation
import SwiftData

struct WalletSummary {
    let accounts: [AccountModel]
    let cards: [CardModel]
}

protocol WalletUseCaseProtocol {
    func loadData() async throws -> WalletSummary
    func deleteAccount(_ account: AccountModel) async throws
    func deleteCard(_ card: CardModel) async throws
    func updateAccountOrder(_ accounts: [AccountModel]) async throws
    func updateCardOrder(_ cards: [CardModel]) async throws
}

final class WalletUseCase: WalletUseCaseProtocol {
    private let accountsService: AccountsServiceProtocol
    private let cardsService: CardsServiceProtocol
    
    init(accountsService: AccountsServiceProtocol, cardsService: CardsServiceProtocol) {
        self.accountsService = accountsService
        self.cardsService = cardsService
    }
    
    func loadData() async throws -> WalletSummary {
        async let accountsTask = accountsService.fetchAccounts()
        async let cardsTask = cardsService.fetchCards()
        
        let accounts = try await accountsTask
        let cards = try await cardsTask
        
        return WalletSummary(accounts: accounts, cards: cards)
    }
    
    func deleteAccount(_ account: AccountModel) async throws {
        // Validation logic moved from View
        if !account.linkedCards.isEmpty {
            throw WalletError.accountHasLinkedCards
        }
        try await accountsService.delete(account)
    }
    
    func deleteCard(_ card: CardModel) async throws {
        try await cardsService.delete(card)
    }
    
    func updateAccountOrder(_ accounts: [AccountModel]) async throws {
        for (index, account) in accounts.enumerated() {
            account.orderIndex = index
        }
        // Saving is handled by the context automatically or needs explicit save if context is not autosaving.
        // Assuming autosave or that modifying managed objects persists.
    }
    
    func updateCardOrder(_ cards: [CardModel]) async throws {
        for (index, card) in cards.enumerated() {
            card.orderIndex = index
        }
    }
}

enum WalletError: LocalizedError {
    case accountHasLinkedCards
    
    var errorDescription: String? {
        switch self {
        case .accountHasLinkedCards:
            return "This account cannot be deleted because it has debit cards linked to it. Please delete or re-assign the cards first."
        }
    }
}
