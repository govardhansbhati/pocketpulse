//
//  AppDI.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftData
import SwiftUI

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
        let schema = Schema(versionedSchema: PocketPulseLatestSchema.self)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(
            for: schema,
            migrationPlan: PocketPulseMigrationPlan.self,
            configurations: [modelConfiguration]
        )
    }
    
    /// Builds an in-memory ModelContainer for fallback or preview scenarios.
    static func buildInMemoryModelContainer(schemaType: any VersionedSchema.Type = PocketPulseLatestSchema.self)
    throws -> ModelContainer {
        let schema = Schema(versionedSchema: schemaType)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: schema,
            migrationPlan: PocketPulseMigrationPlan.self,
            configurations: [modelConfiguration]
        )
    }
    
    /// Attempts to build the persistent container, falling back to in-memory on failure.
    ///
    /// - Returns: A tuple containing the created `ModelContainer` and an optional `AppError` if a fallback occurred.
    /// Attempts to build the persistent container, falling back to in-memory on failure.
    ///
    /// - Returns: A tuple containing the created `ModelContainer` and an optional `AppError` if a fallback occurred.
    /// Attempts to build the persistent container, falling back to in-memory on failure.
    ///
    /// - Returns: A tuple containing the created `ModelContainer` and an optional `AppError` if a fallback occurred.
    /// Attempts to build the persistent container, falling back to in-memory on failure.
    ///
    /// - Returns: A tuple containing the created `ModelContainer` and an optional `AppError` if a fallback occurred.
    static func makeSafeContainer() -> (ModelContainer, AppError?) {
        let environment = AppConfiguration.currentEnvironment
        
        print("🌍 App Environment: \(environment)")
        
        switch environment {
        case .demo:
            print("🚀 Launching in Demo Mode with Mock Data")
            do {
                // Use Mock Schema
                let memoryContainer = try AppDI.buildInMemoryModelContainer(schemaType: PocketPulseMockSchema.self)
                MockDataSeeder.seed(context: memoryContainer.mainContext)
                return (memoryContainer, nil)
            } catch {
                fatalError("Failed to create Demo Mode container: \(error)")
            }
            
        case .debug:
            print("🐞 Launching in Development Mode (PocketPulse-Dev.store)")
            // Use Dev Schema
            return makePersistentContainer(storeName: "PocketPulse-Dev.store", schemaType: PocketPulseDevSchema.self)
            
        case .production:
            print("🏭 Launching in Production Mode")
            // Use Prod Schema
            return makePersistentContainer(storeName: nil, schemaType: PocketPulseProdSchema.self)
        }
    }
    
    /// Helper to create persistent container with specific store name and schema.
    private static func makePersistentContainer(storeName: String?,
                                                schemaType: any VersionedSchema.Type) -> (ModelContainer, AppError?) {
        do {
            let schema = Schema(versionedSchema: schemaType)
            
            var modelConfiguration: ModelConfiguration
            if let storeName = storeName,
                let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
                let url = appSupport.appendingPathComponent(storeName)
                modelConfiguration = ModelConfiguration(schema: schema, url: url)
            } else {
                // Default Prod URL
                modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            }

            let container = try ModelContainer(
                for: schema,
                migrationPlan: PocketPulseMigrationPlan.self,
                configurations: [modelConfiguration]
            )
            return (container, nil)
        } catch {
            print(String(format: AppConstants.Strings.criticalStorageFailure, error.localizedDescription))
            let appErr = AppError.storage(message: error.localizedDescription)
            
            // Fallback to in-memory using LatestSchema (or could pass schemaType if preferred, but Latest is safe fallback)
            if let memoryContainer = try? AppDI.buildInMemoryModelContainer(schemaType: PocketPulseLatestSchema.self) {
                return (memoryContainer, appErr)
            } else {
                fatalError(String(format: AppConstants.Strings.criticalInMemoryFallbackFailure,
                                  error.localizedDescription))
            }
        }
    }
}
