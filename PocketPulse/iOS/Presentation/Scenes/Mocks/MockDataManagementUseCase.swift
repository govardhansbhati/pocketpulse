//
//  MockDataManagementUseCase.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation

class MockDataManagementUseCase: DataManagementUseCaseProtocol {
    private let csvString = "Title,Amount,Date,Type,Category\nTest,100.00,Jan 1 2025,Expense,Food"
    
    func generateCSV() async throws -> Data? {
        // Return dummy CSV data
        return Data(csvString.utf8)
    }
    
    func resetAllData() async throws {
        // No-op for mock
        print("Mock reset all data")
    }
}
