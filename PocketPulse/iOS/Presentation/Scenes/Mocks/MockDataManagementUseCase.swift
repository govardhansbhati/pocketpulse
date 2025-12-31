//
//  MockDataManagementUseCase.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation

class MockDataManagementUseCase: DataManagementUseCaseProtocol {
    func generateCSV() async throws -> Data? {
        // Return dummy CSV data
        return "Title,Amount,Date,Type,Category\nTest,100.00,Jan 1 2025,Expense,Food".data(using: .utf8)
    }
    
    func resetAllData() async throws {
        // No-op for mock
        print("Mock reset all data")
    }
}
