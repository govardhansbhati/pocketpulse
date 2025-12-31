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
}
