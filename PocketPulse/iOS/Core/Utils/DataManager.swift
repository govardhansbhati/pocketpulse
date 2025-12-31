//
//  DataManager.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation
import SwiftData

class DataManager {
    
    // MARK: - CSV Generation
    
    static func generateCSV(from transactions: [TransactionModel]) -> Data? {
        var csvString = "Title,Amount,Date,Type,Category\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        for transaction in transactions {
            let title = transaction.title.replacingOccurrences(of: ",", with: " ")
            let amount = String(format: "%.2f", transaction.amount)
            let date = dateFormatter.string(from: transaction.date)
            let type = transaction.type.rawValue
            let category = transaction.category.displayName
            
            let row = "\(title),\(amount),\(date),\(type),\(category)\n"
            csvString.append(row)
        }
        
        return csvString.data(using: .utf8)
    }
    
    // MARK: - Data Reset
    
    static func resetAllData(in context: ModelContext) {
        do {
            try context.delete(model: TransactionModel.self)
            try context.delete(model: AccountModel.self)
            try context.delete(model: CardModel.self)
            try context.delete(model: BillModel.self)
            try context.delete(model: BorrowLendModel.self)
        } catch {
            print("Failed to reset data: \(error)")
        }
    }
}
