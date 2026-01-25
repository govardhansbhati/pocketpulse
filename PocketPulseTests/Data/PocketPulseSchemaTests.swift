import Testing
import SwiftData
@testable import PocketPulse

struct PocketPulseSchemaTests {

    @Test func schemaVersionCheck() {
        #expect(PocketPulseSchemaV1.versionIdentifier == Schema.Version(1, 0, 0))
    }

    @Test func schemaModelsCheck() {
        let models = PocketPulseSchemaV1.models
        #expect(!models.isEmpty)
        #expect(models.count == 6)
        
        let modelNames = models.map { String(describing: $0) }
        #expect(modelNames.contains("AccountModel"))
        #expect(modelNames.contains("CardModel"))
        #expect(modelNames.contains("TransactionModel"))
        #expect(modelNames.contains("BorrowLendModel"))
        #expect(modelNames.contains("BillModel"))
        #expect(modelNames.contains("NotificationModel"))
    }
}
