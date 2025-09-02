//
//  DataManager.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//
import SwiftUI
import SwiftData

// MARK: - Data Manager
/// A utility struct to handle all business logic related to data management.
struct DataManager {
    /// Deletes all SwiftData models and resets relevant UserDefaults.
    static func resetAllData(in context: ModelContext) {
        // Delete all instances of each model type.
        try? context.delete(model: TransactionModel.self)
        try? context.delete(model: CardModel.self)
        try? context.delete(model: AccountModel.self)
        try? context.delete(model: BillModel.self)
        try? context.delete(model: BorrowLendModel.self)
        
        // Reset user profile and settings stored in UserDefaults.
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "dailyReminderEnabled")
        UserDefaults.standard.removeObject(forKey: "dailyReminderTime")
        UserDefaults.standard.removeObject(forKey: "isPasscodeEnabled")
        KeychainManager.deletePasscode()
        
        print("All app data has been reset.")
    }
    
    /// Generates a CSV-formatted `Data` object from an array of transactions.
    static func generateCSV(from transactions: [TransactionModel]) -> Data? {
        var csvString = "Date,Title,Type,Category,Amount\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        for transaction in transactions {
            let date = dateFormatter.string(from: transaction.date)
            let title = transaction.title.replacingOccurrences(of: ",", with: "") // Basic sanitization for CSV
            let type = transaction.type.rawValue
            let category = transaction.category.rawValue
            let amount = String(transaction.amount)
            
            csvString.append("\(date),\(title),\(type),\(category),\(amount)\n")
        }
        
        return csvString.data(using: .utf8)
    }
}
