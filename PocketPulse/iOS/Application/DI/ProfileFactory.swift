//
//  ProfileFactory.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import SwiftUI
import SwiftData

struct ProfileFactory {
    let container: AppContainer
    let context: ModelContext
    
    init(container: AppContainer = .shared, context: ModelContext) {
        self.container = container
        self.context = context
    }
    
    func makeDataManagementUseCase() -> DataManagementUseCaseProtocol {
        container.makeDataManagementUseCase(context: context)
    }
    
    @MainActor func makeDataManagementViewModel() -> DataManagementViewModel {
        DataManagementViewModel(useCase: makeDataManagementUseCase())
    }
    
    @MainActor func makeDataManagementView() -> some View {
        DataManagementView(viewModel: makeDataManagementViewModel())
    }
}
