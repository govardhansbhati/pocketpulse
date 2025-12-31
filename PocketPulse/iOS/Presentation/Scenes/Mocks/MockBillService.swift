//
//  MockBillService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import Foundation
import SwiftData

final class MockBillService: BillServiceProtocol {
    func fetchBills() async throws -> [BillModel] {
        return [
            BillModel(title: "Electricity Bill", amount: 1200, dueDate: Date().addingTimeInterval(86400 * 5)),
            BillModel(title: "Internet", amount: 999, dueDate: Date().addingTimeInterval(86400 * 2))
        ]
    }
    
    func fetchBorrowLendItems() async throws -> [BorrowLendModel] {
        return [
            BorrowLendModel(name: "John", amount: 500, contact: "+910090930293", type: .borrowed, dueDate: Date()),
            BorrowLendModel(name: "Alice", amount: 1500, contact: "+9194039403", type: .lent, dueDate: Date().addingTimeInterval(-86400))
        ]
    }
    
    func delete(_ item: any PersistentModel) async throws {
        // Mock deletion
    }
    
    func deleteAll() async throws {}
}
