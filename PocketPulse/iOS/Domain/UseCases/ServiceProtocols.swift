//
//  ServiceProtocols.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import Foundation
import SwiftData

protocol AccountsServiceProtocol {
    func fetchAccounts() async throws -> [AccountModel]
}

protocol CardsServiceProtocol {
    func fetchCards() async throws -> [CardModel]
}

protocol TransactionsServiceProtocol {
    func fetchTransactions() async throws -> [TransactionModel]
}

protocol BillServiceProtocol {
    func fetchBills() async throws -> [BillModel]
    func fetchBorrowLendItems() async throws -> [BorrowLendModel]
    func delete(_ item: any PersistentModel) async throws
}

