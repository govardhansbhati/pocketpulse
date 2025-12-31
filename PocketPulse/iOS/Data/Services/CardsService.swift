//
//  CardsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//


import SwiftData
import Foundation

final class CardsService: CardsServiceProtocol {
    private let context: ModelContext
    public init(context: ModelContext) { self.context = context }
    public func fetchCards() async throws -> [CardModel] {
        let descriptor = FetchDescriptor<CardModel>(sortBy: [SortDescriptor(\.orderIndex)])
        return try context.fetch(descriptor)
    }
    
    public func add(_ item: CardModel) async throws {
        context.insert(item)
    }
    
    public func update(_ item: CardModel) async throws {
        try context.save()
    }

    public func delete(_ item: CardModel) async throws {
        context.delete(item)
    }
    
    public func deleteAll() async throws {
        try context.delete(model: CardModel.self)
    }
}
