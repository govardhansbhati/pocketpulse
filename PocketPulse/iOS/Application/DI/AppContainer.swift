//
//  AppContainer.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//


import SwiftData

final class AppContainer {
    static let shared = AppContainer()
    private init() {}
    
    func makeAccountsService(context: ModelContext) -> AccountsServiceProtocol {
        AccountsService(context: context)
    }
    func makeCardsService(context: ModelContext) -> CardsServiceProtocol {
        CardsService(context: context)
    }
    func makeTransactionsService(context: ModelContext) -> TransactionsServiceProtocol {
        TransactionsService(context: context)
    }
    func makeBillService(context: ModelContext) -> BillServiceProtocol {
        BillService(context: context)
    }

}