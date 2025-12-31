//
//  MockTransactionUseCase.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation

class MockTransactionUseCase: TransactionUseCaseProtocol {
    func add(transaction: TransactionModel) async throws {
        // No-op for mock
        print("Mock added transaction: \(transaction.title)")
    }
    
    func update(transaction: TransactionModel) async throws {
        // No-op for mock
        print("Mock updated transaction: \(transaction.title)")
    }
    
    func delete(transaction: TransactionModel) async throws {
        // No-op for mock
        print("Mock deleted transaction: \(transaction.title)")
    }
}
