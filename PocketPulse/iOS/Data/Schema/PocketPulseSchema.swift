//
//  PocketPulseSchema.swift
//  PocketPulse
//
//  Created by Govardhan Singh on 17/01/26.
//

import SwiftData
import Foundation

/// The Versioned Schema definition for PocketPulse.
/// Any future schema changes must be defined in a new version (e.g., PocketPulseSchemaV2)
/// and added to the PocketPulseMigrationPlan.
enum PocketPulseSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            AccountModel.self,
            CardModel.self,
            TransactionModel.self,
            BorrowLendModel.self,
            BillModel.self,
            NotificationEntity.self
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
