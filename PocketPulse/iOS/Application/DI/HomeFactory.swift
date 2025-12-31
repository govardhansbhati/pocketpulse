//
//  HomeFactory.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//


import SwiftUI
import SwiftData

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
            transactionUseCase: container.makeTransactionUseCase(context: context)
        )
    }
    
    @MainActor func makeHomeView() -> some View {
        HomeView(viewModel: makeHomeViewModel())
    }
}
