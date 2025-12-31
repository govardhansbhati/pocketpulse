//
//  TransactionUseCase.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation
import SwiftData

protocol TransactionUseCaseProtocol {
    func add(transaction: TransactionModel) async throws
    func update(transaction: TransactionModel) async throws
    func delete(transaction: TransactionModel) async throws
}

final class TransactionUseCase: TransactionUseCaseProtocol {
    private let service: TransactionsServiceProtocol
    
    init(service: TransactionsServiceProtocol) {
        self.service = service
    }
    
    func add(transaction: TransactionModel) async throws {
        try await service.add(transaction)
    }
    
    func update(transaction: TransactionModel) async throws {
        try await service.update(transaction)
    }
    
    func delete(transaction: TransactionModel) async throws {
        try await service.delete(transaction)
    }
}
