//
//  WalletFactory.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import SwiftData
import SwiftUI

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
        WalletViewModel(useCase: makeUseCase(), dataUpdateService: container.makeDataUpdateService())
    }
    
    @MainActor func makeWalletView() -> some View {
        WalletView(viewModel: makeWalletViewModel())
    }
    
    @MainActor func makeAddCardSheet(cardToEdit: CardModel?, onSave: @escaping () -> Void) -> some View {
        let service = container.makeCardsService(context: context)
        let useCase = CardUseCase(service: service)
        let viewModel = AddCardViewModel(useCase: useCase, dataUpdateService: container.makeDataUpdateService())
        return AddCardSheet(viewModel: viewModel, cardToEdit: cardToEdit, onSave: onSave)
    }
    
    @MainActor func makeAddAccountSheet(accountToEdit: AccountModel?, onSave: @escaping () -> Void) -> some View {
        let service = container.makeAccountsService(context: context)
        let useCase = AccountUseCase(service: service)
        let viewModel = AddAccountViewModel(useCase: useCase, dataUpdateService: container.makeDataUpdateService())
        return AddAccountSheet(viewModel: viewModel, accountToEdit: accountToEdit, onSave: onSave)
    }
}
