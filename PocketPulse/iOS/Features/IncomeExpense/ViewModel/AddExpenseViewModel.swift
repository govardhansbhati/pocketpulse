//
//  AddExpenseViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import Foundation
import SwiftUI
import SwiftData

class AddExpenseViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var category: TransactionCategory = .food // Default expense category
    @Published var date: Date = .now
    @Published var selectedAccount: AccountModel?

    func saveTransaction(context: ModelContext) -> Result<Void, ValidationError> {
        guard !title.isEmpty else { return .failure(.missingTitle) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        guard let account = selectedAccount else { return .failure(.missingAccount) }

        let newTransaction = TransactionModel(
            title: title,
            amount: amountValue,
            type: .expense, // Hardcoded type
            category: category,
            date: date,
            linkedAccountID: account.id
        )
        context.insert(newTransaction)
        
        // Subtract from balance for expenses
        account.balance -= amountValue
        
        return .success(())
    }
}
