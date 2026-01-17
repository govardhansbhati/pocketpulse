# SwiftData Migration Guide

This project uses `VersionedSchema` and `SchemaMigrationPlan` to handle SwiftData model changes safely.

## Current Setup
- **Schema File**: `iOS/Data/Schema/PocketPulseSchema.swift`
- **Current Version**: `PocketPulseSchemaV1`
- **Migration Plan**: `PocketPulseMigrationPlan`

## How to add a new Schema Version

When you need to modify existing models (add/remove properties, rename) in a way that requires migration:

1. **Define the new Versioned Schema**:
   In `PocketPulseSchema.swift`, define `PocketPulseSchemaV2`:
   ```swift
   enum PocketPulseSchemaV2: VersionedSchema {
       static var versionIdentifier = Schema.Version(2, 0, 0)
       static var models: [any PersistentModel.Type] {
           [
                // List ALL models here. 
                // If a model changed, you might need to define a new class nested in this enum 
                // OR ensure the top-level class matches this version's expectations.
                // Typically, for heavy migrations, you define `V2.AccountModel` etc.
                AccountModel.self, 
                // ...
           ]
       }
   }
   ```

2. **Update the Migration Plan**:
   In `PocketPulseSchema.swift`, update `PocketPulseMigrationPlan`:
   ```swift
   enum PocketPulseMigrationPlan: SchemaMigrationPlan {
       static var schemas: [any VersionedSchema.Type] {
           [
               PocketPulseSchemaV1.self,
               PocketPulseSchemaV2.self // Add new version
           ]
       }
       
       static var stages: [MigrationStage] {
           [
               migrateV1toV2
           ]
       }
       
       static let migrateV1toV2 = MigrationStage.custom(
           fromVersion: PocketPulseSchemaV1.self,
           toVersion: PocketPulseSchemaV2.self,
           willMigrate: { context in
               // Pre-migration logic
           },
           didMigrate: { context in
               // Post-migration logic
           }
       )
       // OR use .lightweight if changes are simple (adding optional property, etc.)
       // static let migrateV1toV2 = MigrationStage.lightweight(
       //     fromVersion: PocketPulseSchemaV1.self,
       //     toVersion: PocketPulseSchemaV2.self
       // )
   }
   ```

3. **Verify**:
   Build and run. SwiftData will automatically detect the current version on disk and upgrade it using the defined stages.

## Important Notes
- Always test migrations on a device with existing data.
- Never modify a released schema version (e.g., V1) once it's in production. Always create a new version.
