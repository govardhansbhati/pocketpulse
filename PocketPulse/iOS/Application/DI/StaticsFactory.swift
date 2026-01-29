//
//  StaticsFactory.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import SwiftData
import SwiftUI

struct StaticsFactory {
    let container: AppContainer
    let context: ModelContext
    
    init(container: AppContainer = .shared, context: ModelContext) {
        self.container = container
        self.context = context
    }
    
    func makeUseCase() -> StaticsUseCaseProtocol {
        let transactions = container.makeTransactionsService(context: context)
        return StaticsUseCase(transactions: transactions)
    }
    
    @MainActor func makeStaticsViewModel() -> StaticsViewModel {
        StaticsViewModel(
            useCase: makeUseCase(),
            transactionUseCase: container.makeTransactionUseCase(context: context),
            dataUpdateService: container.makeDataUpdateService()
        )
    }
    
    @MainActor func makeStaticsView() -> some View {
        StaticsView(viewModel: makeStaticsViewModel())
    }
}
