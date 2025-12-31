//
//  BillService.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/25.
//

import SwiftData
import Foundation

final class BillService: BillServiceProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchBills() async throws -> [BillModel] {
        let descriptor = FetchDescriptor<BillModel>(sortBy: [SortDescriptor(\.dueDate)])
        return try context.fetch(descriptor)
    }
    
    func fetchBorrowLendItems() async throws -> [BorrowLendModel] {
        let descriptor = FetchDescriptor<BorrowLendModel>(sortBy: [SortDescriptor(\.name)])
        return try context.fetch(descriptor)
    }
    
    func delete(_ item: any PersistentModel) async throws {
        context.delete(item)
    }
    
    func deleteAll() async throws {
        try context.delete(model: BillModel.self)
        try context.delete(model: BorrowLendModel.self)
    }
}
