//
//  PocketPulseSchema.swift
//  PocketPulse
//
//  Created by Govardhan Singh on 17/01/26.
//

import Foundation
import SwiftData

// The Versioned Schema definition for PocketPulse.
// Any future schema changes must be defined in a new version (e.g., PocketPulseSchemaV2)
// and added to the PocketPulseMigrationPlan.
// Point these to your desired schema version for each environment.
// This allows you to test migrations in Dev without affecting Prod.

// MARK: - Environment Configuration

/// 🛠️ DEVELOPER: Change this when testing a NEW schema (e.g., PocketPulseSchemaV2) locally.
typealias PocketPulseDevSchema = PocketPulseSchemaV1

/// 🚀 RELEASE: Change this ONLY when you are ready to ship the new schema to the App Store.
typealias PocketPulseProdSchema = PocketPulseSchemaV1

/// 🎭 MOCK/DEMO: Change this to update the schema used in Demo Mode.
typealias PocketPulseMockSchema = PocketPulseSchemaV1

/// specific alias for backward compatibility or general generic usage
typealias PocketPulseLatestSchema = PocketPulseSchemaV1

/// Version 1 of the PocketPulse SwiftData schema.
enum PocketPulseSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            AccountModel.self,
            CardModel.self,
            TransactionModel.self,
            BorrowLendModel.self,
            BillModel.self,
            NotificationModel.self
        ]
    }
}

/// The Migration Plan handling transitions between schema versions.
enum PocketPulseMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            PocketPulseSchemaV1.self
            // Future versions will be added here:
            // PocketPulseSchemaV2.self
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            // Example for future migration:
            // migrateV1toV2
        ]
    }
    
    // Example of a migration stage definition logic:
    // static let migrateV1toV2 = MigrationStage.custom(
    //     fromVersion: PocketPulseSchemaV1.self,
    //     toVersion: PocketPulseSchemaV2.self,
    //     willMigrate: { context in
    //         // Custom migration logic if needed before schema update
    //     },
    //     didMigrate: { context in
    //         // Custom migration logic if needed after schema update
    //     }
    // )
}
