//
//  TransactionFactory.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import SwiftUI
import SwiftData

struct TransactionFactory {
    let container: AppContainer
    let context: ModelContext
    
    init(container: AppContainer = .shared, context: ModelContext) {
        self.container = container
        self.context = context
    }
    
    func makeUseCase() -> TransactionUseCaseProtocol {
        container.makeTransactionUseCase(context: context)
    }
    
    @MainActor func makeTransactionListViewModel() -> TransactionListViewModel {
        TransactionListViewModel(
            useCase: makeUseCase(),
            transactionsService: container.makeTransactionsService(context: context)
        )
    }
    
    @MainActor func makeTransactionListView() -> some View {
        TransactionListView(viewModel: makeTransactionListViewModel())
    }
    
    @MainActor func makeAddExpenseView() -> some View {
        let transactionsService = container.makeTransactionsService(context: context)
        let accountsService = container.makeAccountsService(context: context)
        let cardsService = container.makeCardsService(context: context)
        
        let transactionUseCase = TransactionUseCase(service: transactionsService)
        let accountUseCase = AccountUseCase(service: accountsService)
        let cardUseCase = CardUseCase(service: cardsService)
        
        let viewModel = AddExpenseViewModel(
            transactionUseCase: transactionUseCase,
            accountUseCase: accountUseCase,
            cardUseCase: cardUseCase
        )
        return AddExpenseView(viewModel: viewModel)
    }
    
    @MainActor func makeAddIncomeView() -> some View {
        let transactionsService = container.makeTransactionsService(context: context)
        let accountsService = container.makeAccountsService(context: context)
        
        let transactionUseCase = TransactionUseCase(service: transactionsService)
        let accountUseCase = AccountUseCase(service: accountsService)
        
        let viewModel = AddIncomeViewModel(
            transactionUseCase: transactionUseCase,
            accountUseCase: accountUseCase
        )
        return AddIncomeView(viewModel: viewModel)
    }
}
