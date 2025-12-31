//
//  MockCardsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import Foundation

final class MockCardsService: CardsServiceProtocol {
    func fetchCards() async throws -> [CardModel] {
        MockData.cards
    }
    func delete(_ item: CardModel) async throws {}
    func deleteAll() async throws {}
}
