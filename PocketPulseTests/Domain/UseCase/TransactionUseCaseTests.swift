//
//  TransactionUseCaseTests.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import Foundation
@testable import PocketPulse
import Testing

@Suite("Transaction Use Case Tests")
struct TransactionUseCaseTests {
    let service: MockTransactionsService
    let accountService: MockAccountsService
    let cardService: MockCardsService
    let useCase: TransactionUseCase
    
    init() {
        self.service = MockTransactionsService()
        self.accountService = MockAccountsService()
        self.cardService = MockCardsService()
        self.useCase = TransactionUseCase(
            service: service,
            accountService: accountService,
            cardService: cardService
        )
    }
    
    @Test("Add Transaction")
    func addTransaction() async throws {
        // Given
        let transaction = TransactionModel(
            title: "Test Expense",
            amount: 100.0,
            type: .expense,
            category: .food,
            date: Date()
        )
        let initialCount = try await service.fetchTransactions().count
        
        // When
        try await useCase.add(transaction: transaction)
        
        // Then
        let transactions = try await service.fetchTransactions()
        #expect(transactions.count == initialCount + 1)
        #expect(transactions.last?.title == "Test Expense")
    }
    
    @Test("Update Transaction")
    func updateTransaction() async throws {
        // Given
        let transaction = TransactionModel(
            title: "Old Title",
            amount: 50.0,
            type: .expense,
            category: .transport,
            date: Date()
        )
        try await useCase.add(transaction: transaction)
        
        let transactions = try await service.fetchTransactions()
        guard var savedTransaction = transactions.last else {
            Issue.record("Failed to fetch saved transaction")
            return
        }
        
        // When
        savedTransaction.title = "New Title"
        try await useCase.update(transaction: savedTransaction)
        
        // Then
        let updatedTransactions = try await service.fetchTransactions()
        let updatedTransaction = updatedTransactions.first(where: { $0.id == savedTransaction.id })
        #expect(updatedTransaction?.title == "New Title")
    }
    
    @Test("Delete Transaction")
    func deleteTransaction() async throws {
        // Given
        let transaction = TransactionModel(
            title: "To Delete",
            amount: 10.0,
            type: .expense,
            category: .bills,
            date: Date()
        )
        try await useCase.add(transaction: transaction)
        let countAfterAdd = try await service.fetchTransactions().count
        
        let transactions = try await service.fetchTransactions()
        guard let savedTransaction = transactions.last else {
            Issue.record("Failed to fetch saved transaction")
            return
        }
        
        // When
        try await useCase.delete(transaction: savedTransaction)
        
        // Then
        let countAfterDelete = try await service.fetchTransactions().count
        #expect(countAfterDelete == countAfterAdd - 1)
    }
}
