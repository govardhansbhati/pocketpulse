//
//  CardUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 02/09/25.
//

import Foundation

protocol CardUseCaseProtocol {
    func add(card: CardModel) async throws
    func update(card: CardModel) async throws
    func delete(card: CardModel) async throws
    func fetchCards() async throws -> [CardModel]
}

final class CardUseCase: CardUseCaseProtocol {
    private let service: CardsServiceProtocol
    
    init(service: CardsServiceProtocol) {
        self.service = service
    }
    
    func add(card: CardModel) async throws {
        try await service.add(card)
    }
    
    func update(card: CardModel) async throws {
        try await service.update(card)
    }
    
    func delete(card: CardModel) async throws {
        try await service.delete(card)
    }
    
    func fetchCards() async throws -> [CardModel] {
        try await service.fetchCards()
    }
}
