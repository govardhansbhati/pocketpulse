//
//  MockWalletUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import Foundation

final class MockWalletUseCase: WalletUseCaseProtocol {
    func loadData() async throws -> WalletSummary {
        WalletSummary(accounts: MockData.accounts, cards: MockData.cards)
    }
    
    func deleteAccount(_ account: AccountModel) async throws {
        // Mock deletion
    }
    
    func deleteCard(_ card: CardModel) async throws {
        // Mock deletion
    }
    
    func updateAccountOrder(_ accounts: [AccountModel]) async throws {
        // Mock reorder
    }
    
    func updateCardOrder(_ cards: [CardModel]) async throws {
        // Mock reorder
    }
}
