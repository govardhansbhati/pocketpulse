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
    
    // Single instance managed by container
    private let dataUpdateService = DataUpdateService.shared
    
    func makeDataUpdateService() -> DataUpdateServiceProtocol {
        dataUpdateService
    }
    
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
    @MainActor func makeNotificationService(context: ModelContext) -> NotificationServiceProtocol {
        NotificationService(context: context)
    }
    
    func makeTransactionUseCase(context: ModelContext) -> TransactionUseCaseProtocol {
        TransactionUseCase(
            service: makeTransactionsService(context: context),
            accountService: makeAccountsService(context: context),
            cardService: makeCardsService(context: context)
        )
    }
    
    func makeDataManagementUseCase(context: ModelContext) -> DataManagementUseCaseProtocol {
        DataManagementUseCase(
            transactionsService: makeTransactionsService(context: context),
            accountsService: makeAccountsService(context: context),
            cardsService: makeCardsService(context: context),
            billService: makeBillService(context: context)
        )
    }

}
