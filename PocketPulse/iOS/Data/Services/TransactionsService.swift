//
//  TransactionsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import SwiftData
import Foundation

final class TransactionsService: TransactionsServiceProtocol {
    private let context: ModelContext
    public init(context: ModelContext) { self.context = context }
    public func fetchTransactions() async throws -> [TransactionModel] {
        let descriptor = FetchDescriptor<TransactionModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    public func add(_ item: TransactionModel) async throws {
        context.insert(item)
    }
    
    public func update(_ item: TransactionModel) async throws {
        try context.save()
    }

    public func delete(_ item: TransactionModel) async throws {
        context.delete(item)
    }
    
    public func deleteAll() async throws {
        try context.delete(model: TransactionModel.self)
    }
}
