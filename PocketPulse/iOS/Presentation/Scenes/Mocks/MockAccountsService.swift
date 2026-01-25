//
//  MockAccountsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import Foundation

final class MockAccountsService: AccountsServiceProtocol {
    
    var accounts: [AccountModel] = MockData.accounts
    
    func fetchAccounts() async throws -> [AccountModel] {
        return accounts
    }
    
    func fetchAccount(id: UUID) async throws -> AccountModel? {
        return accounts.first { $0.id == id }
    }
    
    func add(_ item: AccountModel) async throws {
        accounts.append(item)
    }
    
    func update(_ item: AccountModel) async throws {
        if let index = accounts.firstIndex(where: { $0.id == item.id }) {
            accounts[index] = item
        }
    }
    
    func delete(_ item: AccountModel) async throws {
        accounts.removeAll { $0.id == item.id }
    }
    
    func deleteAll() async throws {
        accounts.removeAll()
    }
}
