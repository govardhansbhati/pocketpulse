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
@MainActor
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
    
    @Test("Add Transfer Transaction Updates Both Account Balances")
    func addTransferTransaction() async throws {
        // Given
        let sourceAccount = AccountModel(
            name: "HDFC Checking",
            institution: "HDFC",
            accountType: .savings,
            balance: 5000.0
        )
        let destinationAccount = AccountModel(
            name: "SBI Savings",
            institution: "SBI",
            accountType: .savings,
            balance: 2000.0
        )
        try await accountService.add(sourceAccount)
        try await accountService.add(destinationAccount)
        
        let transfer = TransactionModel(
            title: "HDFC → SBI",
            amount: 1500.0,
            type: .transfer,
            category: .transfer,
            date: Date(),
            linkedAccountID: sourceAccount.id,
            destinationAccountID: destinationAccount.id
        )
        
        // When
        try await useCase.add(transaction: transfer)
        
        // Then
        let updatedSource = try await accountService.fetchAccount(id: sourceAccount.id)
        let updatedDest = try await accountService.fetchAccount(id: destinationAccount.id)
        
        #expect(updatedSource?.balance == 3500.0)
        #expect(updatedDest?.balance == 3500.0)
        
        // And When deleted (reversal)
        try await useCase.delete(transaction: transfer)
        let revertedSource = try await accountService.fetchAccount(id: sourceAccount.id)
        let revertedDest = try await accountService.fetchAccount(id: destinationAccount.id)
        
        #expect(revertedSource?.balance == 5000.0)
        #expect(revertedDest?.balance == 2000.0)
    }
}
