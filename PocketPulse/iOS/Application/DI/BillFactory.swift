//
//  BillFactory.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import SwiftUI
import SwiftData

struct BillFactory {
    let container: AppContainer
    let context: ModelContext
    
    init(container: AppContainer = .shared, context: ModelContext) {
        self.container = container
        self.context = context
    }
    
    func makeUseCase() -> BillUseCaseProtocol {
        let billService = container.makeBillService(context: context)
        let cardsService = container.makeCardsService(context: context)
        return BillUseCase(billService: billService, cardsService: cardsService)
    }
    
    @MainActor func makeBillViewModel() -> BillViewModel {
        BillViewModel(useCase: makeUseCase())
    }
    
    @MainActor func makeBillView() -> some View {
        BillView(viewModel: makeBillViewModel())
    }
}
