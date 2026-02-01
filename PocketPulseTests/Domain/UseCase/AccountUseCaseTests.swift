//
//  AccountUseCaseTests.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import Foundation
import Testing
@testable import PocketPulse

@Suite("Account Use Case Tests")
struct AccountUseCaseTests {
    let service: MockAccountsService
    let useCase: AccountUseCase
    
    init() {
        self.service = MockAccountsService()
        self.useCase = AccountUseCase(service: service)
    }
    
    @Test("Add Account")
    func addAccount() async throws {
        // Given
        let account = AccountModel(name: "Test Account", type: .savings,
                                   balance: 1000,
                                   institution: "Test Bank",
                                   orderIndex: 0)
        let initialCount = try await service.fetchAccounts().count
        
        // When
        try await useCase.add(account: account)
        
        // Then
        let accounts = try await service.fetchAccounts()
        #expect(accounts.count == initialCount + 1)
        #expect(accounts.last?.name == "Test Account")
    }
    
    @Test("Update Account")
    func updateAccount() async throws {
        // Given
        let account = AccountModel(name: "Old Name",
                                   type: .cash,
                                   balance: 500,
                                   institution: "Bank", orderIndex: 0)
        try await useCase.add(account: account)
        var savedAccount = try await service.fetchAccounts().last!
        
        // When
        savedAccount.name = "New Name"
        try await useCase.update(account: savedAccount)
        
        // Then
        let accounts = try await service.fetchAccounts()
        let updatedAccount = accounts.first(where: { $0.id == savedAccount.id })
        #expect(updatedAccount?.name == "New Name")
    }
    
    @Test("Delete Account")
    func deleteAccount() async throws {
        // Given
        let account = AccountModel(name: "Delete Me",
                                   type: .wallet,
                                   balance: 0,
                                   institution: "Bank",
                                   orderIndex: 0)
        try await useCase.add(account: account)
        let savedAccount = try await service.fetchAccounts().last!
        let countAfterAdd = try await service.fetchAccounts().count
        
        // When
        try await useCase.delete(account: savedAccount)
        
        // Then
        let countAfterDelete = try await service.fetchAccounts().count
        #expect(countAfterDelete == countAfterAdd - 1)
    }
}
