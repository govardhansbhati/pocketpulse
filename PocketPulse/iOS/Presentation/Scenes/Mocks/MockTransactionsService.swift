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
    func fetchTransactions() async throws -> [TransactionModel] {
        MockData.transactions
    }
    
    func delete(_ item: TransactionModel) async throws {}
    func deleteAll() async throws {}
}