import Foundation
@testable import PocketPulse
import SwiftData
import Testing

// MARK: - Mocks

final class MockTransactionUseCase: TransactionUseCaseProtocol {
    var addCalled = false
    var updateCalled = false
    var deleteCalled = false
    var shouldThrowError = false
    
    func add(transaction: TransactionModel) async throws {
        if shouldThrowError { throw NSError(domain: "Test", code: 1) }
        addCalled = true
    }
    
    func update(transaction: TransactionModel) async throws {
        if shouldThrowError { throw NSError(domain: "Test", code: 1) }
        updateCalled = true
    }
    
    func delete(transaction: TransactionModel) async throws {
        if shouldThrowError { throw NSError(domain: "Test", code: 1) }
        deleteCalled = true
    }
}

final class MockTransactionsService: TransactionsServiceProtocol {
    var transactionsToReturn: [TransactionModel] = []
    var shouldThrowError = false
    var fetchCalled = false
    
    func fetchTransactions() async throws -> [TransactionModel] {
        fetchCalled = true
        if shouldThrowError { throw NSError(domain: "Test", code: 1) }
        return transactionsToReturn
    }
    
    func add(_ item: TransactionModel) async throws {}
    func update(_ item: TransactionModel) async throws {}
    func delete(_ item: TransactionModel) async throws {}
    func deleteAll() async throws {}
}

// MARK: - Tests

@MainActor
struct TransactionListViewModelTests {
    
    @Test func loadTransactionsSuccess() async {
        // Given
        let mockUseCase = MockTransactionUseCase()
        let mockService = MockTransactionsService()
        let expectedTransaction = TransactionModel(
            title: "Test Transaction",
            amount: 100.0,
            type: .expense,
            category: .food,
            date: Date()
        )
        mockService.transactionsToReturn = [expectedTransaction]
        
        let viewModel = TransactionListViewModel(useCase: mockUseCase, transactionsService: mockService)
        
        // When
        await viewModel.loadTransactions()
        
        // Then
        #expect(viewModel.transactions.count == 1)
        #expect(viewModel.transactions.first?.title == "Test Transaction")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func loadTransactionsFailure() async {
        // Given
        let mockUseCase = MockTransactionUseCase()
        let mockService = MockTransactionsService()
        mockService.shouldThrowError = true
        
        let viewModel = TransactionListViewModel(useCase: mockUseCase, transactionsService: mockService)
        
        // When
        await viewModel.loadTransactions()
        
        // Then
        #expect(viewModel.transactions.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test func deleteTransaction() async {
        // Given
        let mockUseCase = MockTransactionUseCase()
        let mockService = MockTransactionsService()
        let transaction = TransactionModel(
            title: "To Delete",
            amount: 50.0,
            type: .expense,
            category: .transport,
            date: Date()
        )
        
        let viewModel = TransactionListViewModel(useCase: mockUseCase, transactionsService: mockService)
        
        // When
        await viewModel.delete(transaction: transaction)
        
        // Then
        #expect(mockUseCase.deleteCalled == true)
        #expect(mockService.fetchCalled == true) // loadTransactions called after delete
    }
}
