//
//  AppDI.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftUI
import SwiftData

/// The central Dependency Injection container for the application.
/// It holds the `ModelContainer` and fundamental services.
@MainActor
final class AppDI {
    
    // MARK: - Core Dependencies
    
    /// The SwiftData ModelContainer.
    let modelContainer: ModelContainer
    
    /// The NavigationCoordinator managing root app flow.
    let navigationCoordinator: NavigationCoordinator
    
    /// The existing AppContainer to bridge legacy DI needs during migration.
    // In a full refactor, we might merge AppContainer into this, but for now we keep it compatible.
    // We update the shared instance context when we initialize.
    
    // MARK: - Initialization
    
    init(container: ModelContainer) {
        self.modelContainer = container
        self.navigationCoordinator = NavigationCoordinator()
        
        // Initialize Core ViewModels that act as singletons/environment objects
        let profileService = ProfileService()
        let profileUseCase = ProfileUseCase(service: profileService)
        self.profileViewModel = ProfileViewModel(useCase: profileUseCase)
        
        // Ensure the AppContainer.shared gets the functionality if it relied on singletons,
        // but currently AppContainer is a factory passed context manually.
        // We will expose factories here.
    }
    
    // MARK: - Factory Methods
    
    /// Returns the main ModelContext from the container.
    var mainContext: ModelContext {
        modelContainer.mainContext
    }
    
    // Example of exposing a factory if needed, though AppContainer handles most services
    // We can bridge to AppContainer for simplicity in this refactor step
    
    // MARK: - ViewModels
    
    // We hold this here to ensure it persists and can be injected into the environment
    let profileViewModel: ProfileViewModel
    
    // MARK: - Static Builders
    
    /// Attempts to build the default persistent ModelContainer.
    static func buildDefaultDBModelContainer() throws -> ModelContainer {
        let schema = Schema([
            AccountModel.self,
            CardModel.self,
            TransactionModel.self,
            BorrowLendModel.self,
            BillModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
    
    /// Builds an in-memory ModelContainer for fallback or preview scenarios.
    static func buildInMemoryModelContainer() throws -> ModelContainer {
        let schema = Schema([
            AccountModel.self,
            CardModel.self,
            TransactionModel.self,
            BorrowLendModel.self,
            BillModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}
