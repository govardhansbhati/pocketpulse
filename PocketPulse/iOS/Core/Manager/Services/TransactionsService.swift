//
//  TransactionsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//


import SwiftData
import Foundation

final class TransactionsService: TransactionsServiceProtocol {
    private let context: ModelContext
    public init(context: ModelContext) { self.context = context }
    public func fetchTransactions() async throws -> [TransactionModel] {
        let descriptor = FetchDescriptor<TransactionModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
}
