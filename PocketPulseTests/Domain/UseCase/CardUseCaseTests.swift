//
//  CardUseCaseTests.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import Foundation
@testable import PocketPulse
import Testing

@Suite("Card Use Case Tests")
struct CardUseCaseTests {
    let service: MockCardsService
    let useCase: CardUseCase
    
    init() {
        self.service = MockCardsService()
        self.useCase = CardUseCase(service: service)
    }
    
    @Test("Add Card")
    func addCard() async throws {
        // Given
        let card = CardModel(
            cardHolderName: "Test User",
            last4Digits: "1234",
            expiryDate: "12/30",
            providerType: .visa,
            cardType: .credit,
            cardDesign: .black,
            bankName: "HDFC",
            orderIndex: 0,
            creditLimit: 100000,
            outstandingBalance: 50000
        )
        let initialCount = try await service.fetchCards().count
        
        // When
        try await useCase.add(card: card)
        
        // Then
        let cards = try await service.fetchCards()
        #expect(cards.count == initialCount + 1)
        #expect(cards.last?.bankName == "HDFC")
    }
    
    @Test("Delete Card")
    func deleteCard() async throws {
        // Given
        let card = CardModel(
            cardHolderName: "Test User",
            last4Digits: "0000",
            expiryDate: "12/30",
            providerType: .masterCard,
            cardType: .debit,
            cardDesign: .black,
            bankName: "Delete",
            orderIndex: 0
        )
        try await useCase.add(card: card)
        let cards = try await service.fetchCards()
        guard let savedCard = cards.last else {
            Issue.record("Failed to fetch saved card")
            return
        }
        let countAfterAdd = cards.count
        
        // When
        try await useCase.delete(card: savedCard)
        
        // Then
        let countAfterDelete = try await service.fetchCards().count
        #expect(countAfterDelete == countAfterAdd - 1)
    }
}
