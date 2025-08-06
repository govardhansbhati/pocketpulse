//
//  AddIncomeViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import Foundation
import SwiftUI
import SwiftData

class AddIncomeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var category: TransactionCategory = .salary // Default income category
    @Published var date: Date = .now
    @Published var selectedAccount: AccountModel?

    func saveTransaction(context: ModelContext) -> Result<Void, ValidationError> {
        guard !title.isEmpty else { return .failure(.missingTitle(field: "title")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        guard let account = selectedAccount else { return .failure(.missingAccount) }

        let newTransaction = TransactionModel(
            title: title,
            amount: amountValue,
            type: .income,
            category: category,
            date: date,
            linkedAccountID: account.id
        )
        context.insert(newTransaction)
        
        // Add to balance for income
        account.balance += amountValue
        
        return .success(())
    }
}
