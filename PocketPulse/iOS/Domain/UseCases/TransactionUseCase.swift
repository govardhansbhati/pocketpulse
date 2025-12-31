//
//  TransactionUseCase.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation
import SwiftData

protocol TransactionUseCaseProtocol {
    func delete(transaction: TransactionModel) async throws
}

final class TransactionUseCase: TransactionUseCaseProtocol {
    private let service: TransactionsServiceProtocol
    
    init(service: TransactionsServiceProtocol) {
        self.service = service
    }
    
    func delete(transaction: TransactionModel) async throws {
        try await service.delete(transaction)
    }
}
