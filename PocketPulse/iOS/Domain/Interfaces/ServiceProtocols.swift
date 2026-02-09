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
    func fetchAccount(id: UUID) async throws -> AccountModel?
    func add(_ item: AccountModel) async throws
    func update(_ item: AccountModel) async throws
    func delete(_ item: AccountModel) async throws
    func deleteAll() async throws
}

protocol CardsServiceProtocol {
    func fetchCards() async throws -> [CardModel]
    func fetchCard(id: UUID) async throws -> CardModel?
    func add(_ item: CardModel) async throws
    func update(_ item: CardModel) async throws
    func delete(_ item: CardModel) async throws
    func deleteAll() async throws
}

protocol TransactionsServiceProtocol {
    func fetchTransactions() async throws -> [TransactionModel]
    func add(_ item: TransactionModel) async throws
    func update(_ item: TransactionModel) async throws
    func delete(_ item: TransactionModel) async throws
    func deleteAll() async throws
}

protocol BillServiceProtocol {
    func fetchBills() async throws -> [BillModel]
    func fetchBorrowLendItems() async throws -> [BorrowLendModel]
    func add(_ item: any PersistentModel) async throws
    func update(_ item: any PersistentModel) async throws
    func delete(_ item: any PersistentModel) async throws
    func deleteAll() async throws
}
