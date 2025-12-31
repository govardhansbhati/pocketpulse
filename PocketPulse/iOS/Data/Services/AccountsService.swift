//
//  AccountsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//


import SwiftData
import Foundation

final class AccountsService: AccountsServiceProtocol {
    private let context: ModelContext
    public init(context: ModelContext) { self.context = context }
    public func fetchAccounts() async throws -> [AccountModel] {
        let descriptor = FetchDescriptor<AccountModel>(sortBy: [SortDescriptor(\.orderIndex)])
        return try context.fetch(descriptor)
    }
    
    public func add(_ item: AccountModel) async throws {
        context.insert(item)
    }
    
    public func update(_ item: AccountModel) async throws {
        try context.save()
    }

    public func delete(_ item: AccountModel) async throws {
        context.delete(item)
    }
    
    public func deleteAll() async throws {
        try context.delete(model: AccountModel.self)
    }
}
