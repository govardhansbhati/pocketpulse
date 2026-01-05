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
        BillViewModel(useCase: makeUseCase(), dataUpdateService: container.makeDataUpdateService())
    }
    
    @MainActor func makeBillView() -> some View {
        BillView(viewModel: makeBillViewModel())
    }

    @MainActor func makeAddBillSheet(billToEdit: BillModel?, onSave: @escaping () -> Void) -> some View {
        let service = container.makeBillService(context: context)
        let cardsService = container.makeCardsService(context: context)
        let useCase = BillUseCase(billService: service, cardsService: cardsService)
        let viewModel = AddBillViewModel(useCase: useCase, dataUpdateService: container.makeDataUpdateService())
        return AddBillSheet(viewModel: viewModel, billToEdit: billToEdit, onSave: onSave)
    }

    @MainActor func makeAddBorrowLendSheet(itemToEdit: BorrowLendModel?, onSave: @escaping () -> Void) -> some View {
        let service = container.makeBillService(context: context)
        let cardsService = container.makeCardsService(context: context)
        let useCase = BillUseCase(billService: service, cardsService: cardsService)
        let viewModel = AddBorrowLendViewModel(useCase: useCase, dataUpdateService: container.makeDataUpdateService())
        return AddBorrowLendSheet(viewModel: viewModel, itemToEdit: itemToEdit, onSave: onSave)
    }
}
