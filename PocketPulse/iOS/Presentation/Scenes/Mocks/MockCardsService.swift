//
//  MockCardsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import Foundation

final class MockCardsService: CardsServiceProtocol {
    
    var cards: [CardModel] = MockData.cards
    
    func fetchCards() async throws -> [CardModel] {
        return cards
    }
    
    func fetchCard(id: UUID) async throws -> CardModel? {
        return cards.first { $0.id == id }
    }
    
    func add(_ item: CardModel) async throws {
        cards.append(item)
    }
    
    func update(_ item: CardModel) async throws {
        if let index = cards.firstIndex(where: { $0.id == item.id }) {
            cards[index] = item
        }
    }
    
    func delete(_ item: CardModel) async throws {
        cards.removeAll { $0.id == item.id }
    }
    
    func deleteAll() async throws {
        cards.removeAll()
    }
}
