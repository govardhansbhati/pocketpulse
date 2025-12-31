//
//  TransactionManager.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation
import SwiftData

class TransactionManager {
    
    // MARK: - Transaction Management
    
    static func delete(transaction: TransactionModel, in context: ModelContext) {
        context.delete(transaction)
        do {
            try context.save()
        } catch {
            print("Error deleting transaction: \(error)")
        }
    }
}
