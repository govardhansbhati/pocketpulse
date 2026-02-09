//
//  HomeFactory.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import SwiftData
import SwiftUI

struct HomeFactory {
    let container: AppContainer
    let context: ModelContext
    
    init(container: AppContainer = .shared, context: ModelContext) {
        self.container = container
        self.context = context
    }
    
    func makeUseCase() -> HomeUseCaseProtocol {
        let accounts = container.makeAccountsService(context: context)
        let cards = container.makeCardsService(context: context)
        let transactions = container.makeTransactionsService(context: context)
        return HomeUseCase(accounts: accounts, cards: cards, transactions: transactions)
    }
    
    @MainActor func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            useCase: makeUseCase(),
            transactionUseCase: container.makeTransactionUseCase(context: context),
            dataUpdateService: container.makeDataUpdateService()
        )
    }
    
    @MainActor func makeHomeView() -> some View {
        HomeView(viewModel: makeHomeViewModel())
    }
    
    @MainActor func makeBreakdownView() -> some View {
        let accounts = container.makeAccountsService(context: context)
        let cards = container.makeCardsService(context: context)
        let walletUseCase = WalletUseCase(accountsService: accounts, cardsService: cards)
        let viewModel = BreakdownViewModel(walletUseCase: walletUseCase)
        return BreakdownView(viewModel: viewModel)
    }
}
