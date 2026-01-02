//
//  NotificationFactory.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftUI
import SwiftData

struct NotificationFactory {
    let container: AppContainer
    let context: ModelContext
    
    init(container: AppContainer = .shared, context: ModelContext) {
        self.container = container
        self.context = context
    }
    
    @MainActor func makeUseCase() -> NotificationUseCaseProtocol {
        let service = container.makeNotificationService(context: context)
        return NotificationUseCase(service: service)
    }
    
    @MainActor func makeNotificationViewModel() -> NotificationViewModel {
        NotificationViewModel(useCase: makeUseCase())
    }
    
    @MainActor func makeNotificationView() -> some View {
        NotificationView(viewModel: makeNotificationViewModel())
    }
}
