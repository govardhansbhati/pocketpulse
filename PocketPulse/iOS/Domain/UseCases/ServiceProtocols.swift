//
//  ServiceProtocols.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import Foundation

protocol AccountsServiceProtocol {
    func fetchAccounts() async throws -> [AccountModel]
}

protocol CardsServiceProtocol {
    func fetchCards() async throws -> [CardModel]
}

protocol TransactionsServiceProtocol {
    func fetchTransactions() async throws -> [TransactionModel]
}
