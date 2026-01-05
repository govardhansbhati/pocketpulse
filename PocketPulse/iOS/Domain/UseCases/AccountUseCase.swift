//
//  AccountUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 02/09/25.
//

import Foundation

protocol AccountUseCaseProtocol {
    func add(account: AccountModel) async throws
    func update(account: AccountModel) async throws
    func delete(account: AccountModel) async throws
    func fetchAccounts() async throws -> [AccountModel]
}

final class AccountUseCase: AccountUseCaseProtocol {
    private let service: AccountsServiceProtocol
    
    init(service: AccountsServiceProtocol) {
        self.service = service
    }
    
    func add(account: AccountModel) async throws {
        try await service.add(account)
    }
    
    func update(account: AccountModel) async throws {
        try await service.update(account)
    }
    
    func delete(account: AccountModel) async throws {
        try await service.delete(account)
    }
    
    func fetchAccounts() async throws -> [AccountModel] {
        try await service.fetchAccounts()
    }
}
