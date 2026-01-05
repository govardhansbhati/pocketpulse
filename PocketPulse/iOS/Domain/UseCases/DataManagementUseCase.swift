//
//  DataManagementUseCase.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation

protocol DataManagementUseCaseProtocol {
    func generateCSV() async throws -> Data?
    func resetAllData() async throws
}

final class DataManagementUseCase: DataManagementUseCaseProtocol {
    private let transactionsService: TransactionsServiceProtocol
    private let accountsService: AccountsServiceProtocol
    private let cardsService: CardsServiceProtocol
    private let billService: BillServiceProtocol
    
    init(
        transactionsService: TransactionsServiceProtocol,
        accountsService: AccountsServiceProtocol,
        cardsService: CardsServiceProtocol,
        billService: BillServiceProtocol
    ) {
        self.transactionsService = transactionsService
        self.accountsService = accountsService
        self.cardsService = cardsService
        self.billService = billService
    }
    
    func generateCSV() async throws -> Data? {
        let transactions = try await transactionsService.fetchTransactions()
        
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
    
    func resetAllData() async throws {
        try await transactionsService.deleteAll()
        try await accountsService.deleteAll()
        try await cardsService.deleteAll()
        try await billService.deleteAll()
    }
}
