//
//  WalletUseCaseTests.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import Testing
import Foundation
@testable import PocketPulse

@Suite("Wallet Use Case Tests")
struct WalletUseCaseTests {
    let accountsService: MockAccountsService
    let cardsService: MockCardsService
    let useCase: WalletUseCase
    
    init() {
        self.accountsService = MockAccountsService()
        self.cardsService = MockCardsService()
        self.useCase = WalletUseCase(accountsService: accountsService, cardsService: cardsService)
    }
    
    @Test("Load Data")
    func loadData() async throws {
        // Given
        try await accountsService.add(AccountModel(name: "A1",
                                                   type: .savings,
                                                   balance: 100,
                                                   institution: "B1",
                                                   orderIndex: 1))
        try await cardsService.add(CardModel(cardHolderName: "Holder",
                                             last4Digits: "1111",
                                             expiryDate: "12/30",
                                             providerType: .visa,
                                             cardType: .credit,
                                             cardDesign: .black,
                                             bankName: "C1",
                                             orderIndex: 0,
                                             outstandingBalance: 200))
        
        // When
        let summary = try await useCase.loadData()
        
        // Then
        #expect(summary.accounts.contains(where: { $0.name == "A1" }))
        #expect(summary.cards.contains(where: { $0.bankName == "C1" }))
    }
    
    @Test("Delete Account With Linked Cards")
    func deleteAccountWithLinkedCards() async throws {
        // Given
        let account = AccountModel(name: "Linked Acc",
                                   type: .savings,
                                   balance: 1000,
                                   institution: "Bank",
                                   orderIndex: 1)
        let card = CardModel(cardHolderName: "Holder",
                             last4Digits: "1234",
                             expiryDate: "12/30",
                             providerType: .visa,
                             cardType: .debit,
                             cardDesign: .black,
                             bankName: "Debit Card",
                             orderIndex: 0)
        card.linkedBankAccount = account
        // Linked cards relationship in SwiftData is managed bidirectionally usually,
        // but here we are using Mocks without CoreData/SwiftData stack. 
        // We need to manually simulate the link if the UseCase checks `account.linkedCards`.
        
        try await accountsService.add(account)
        
        // When
        try await useCase.deleteAccount(account)
        
        // Then
        let accounts = try await accountsService.fetchAccounts()
        #expect(!accounts.contains(where: { $0.id == account.id }))
    }
}
