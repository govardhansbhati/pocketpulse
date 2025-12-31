//
//  WalletFactory.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import SwiftUI
import SwiftData

struct WalletFactory {
    let container: AppContainer
    let context: ModelContext
    
    init(container: AppContainer = .shared, context: ModelContext) {
        self.container = container
        self.context = context
    }
    
    func makeUseCase() -> WalletUseCaseProtocol {
        let accountsService = container.makeAccountsService(context: context)
        let cardsService = container.makeCardsService(context: context)
        return WalletUseCase(accountsService: accountsService, cardsService: cardsService)
    }
    
    @MainActor func makeWalletViewModel() -> WalletViewModel {
        WalletViewModel(useCase: makeUseCase())
    }
    
    @MainActor func makeWalletView() -> some View {
        WalletView(viewModel: makeWalletViewModel())
    }
}
