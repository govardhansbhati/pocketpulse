//
//  MockTransactionsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//


//
//  MockTransactionsService.swift
//  PocketPulse
//

import Foundation

final class MockTransactionsService: TransactionsServiceProtocol {
    var transactions: [TransactionModel] = MockData.transactions
    
    func fetchTransactions() async throws -> [TransactionModel] {
        return transactions
    }
    
    func add(_ item: TransactionModel) async throws {
        transactions.append(item)
    }
    
    func update(_ item: TransactionModel) async throws {
        if let index = transactions.firstIndex(where: { $0.id == item.id }) {
            transactions[index] = item
        }
    }
    
    func delete(_ item: TransactionModel) async throws {
        transactions.removeAll { $0.id == item.id }
    }
    
    func deleteAll() async throws {
        transactions.removeAll()
    }
}