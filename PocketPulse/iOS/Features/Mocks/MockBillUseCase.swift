//
//  MockBillUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import Foundation
import SwiftData

final class MockBillUseCase: BillUseCaseProtocol {
    func loadBillData() async throws -> BillSummary {
         let bills = [
            BillModel(title: "Electricity Bill", amount: 1200, dueDate: Date().addingTimeInterval(86400 * 5)),
            BillModel(title: "Internet", amount: 999, dueDate: Date().addingTimeInterval(86400 * 2)),
             BillModel(title: "HDFC Credit Card", amount: 14500, dueDate: Date().addingTimeInterval(86400 * 10))
        ]
        
        let borrowLend = [
            BorrowLendModel(name: "John", amount: 500, contact: "+910090930293", type: .borrowed, dueDate: Date()),
            BorrowLendModel(name: "Alice", amount: 1500, contact: "+9194039403", type: .lent, dueDate: Date().addingTimeInterval(-86400))
        ]
        
        return BillSummary(combinedBills: bills, borrowLendItems: borrowLend)
    }
    
    func delete(_ item: any PersistentModel) async throws {
        // Mock deletion
    }
}
