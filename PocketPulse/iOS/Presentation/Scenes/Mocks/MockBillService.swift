//
//  MockBillService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import Foundation
import SwiftData

final class MockBillService: BillServiceProtocol {
    var bills: [BillModel] = [
        BillModel(title: "Electricity Bill", amount: 1200, dueDate: Date().addingTimeInterval(86400 * 5)),
        BillModel(title: "Internet", amount: 999, dueDate: Date().addingTimeInterval(86400 * 2))
    ]
    
    var borrowLendItems: [BorrowLendModel] = [
        BorrowLendModel(name: "John", amount: 500, contact: "+910090930293", type: .borrowed, dueDate: Date()),
        BorrowLendModel(name: "Alice", amount: 1500, contact: "+9194039403", type: .lent, dueDate: Date().addingTimeInterval(-86400))
    ]
    
    func fetchBills() async throws -> [BillModel] {
        return bills
    }
    
    func fetchBorrowLendItems() async throws -> [BorrowLendModel] {
        return borrowLendItems
    }
    
    func add(_ item: any PersistentModel) async throws {
        if let bill = item as? BillModel {
            bills.append(bill)
        } else if let borrowLend = item as? BorrowLendModel {
            borrowLendItems.append(borrowLend)
        }
    }
    
    func update(_ item: any PersistentModel) async throws {
        if let bill = item as? BillModel, let index = bills.firstIndex(where: { $0.id == bill.id }) {
            bills[index] = bill
        } else if let borrowLend = item as? BorrowLendModel, let index = borrowLendItems.firstIndex(where: { $0.id == borrowLend.id }) {
            borrowLendItems[index] = borrowLend
        }
    }
    
    func delete(_ item: any PersistentModel) async throws {
        if let bill = item as? BillModel {
            bills.removeAll { $0.id == bill.id }
        } else if let borrowLend = item as? BorrowLendModel {
            borrowLendItems.removeAll { $0.id == borrowLend.id }
        }
    }
    
    func deleteAll() async throws {
        bills.removeAll()
        borrowLendItems.removeAll()
    }
}
