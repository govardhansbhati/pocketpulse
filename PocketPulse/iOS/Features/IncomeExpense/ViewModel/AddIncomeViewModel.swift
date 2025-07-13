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
    @Published var category: TransactionCategory = .salary
    @Published var date: Date = Date()
    @Published var selectedAccount: AccountModel?

    func addIncome(context: ModelContext) -> Bool {
        guard validateInputs(),
              let amountValue = Double(amount),
              let selectedAccount = selectedAccount else {
            return false
        }

        let newTransaction = TransactionModel(
            title: title,
            amount: amountValue,
            type: .income,
            category: category,
            date: date,
            linkedAccountID: selectedAccount.id
        )

        context.insert(newTransaction)

        updateAccountBalance(account: selectedAccount, amount: amountValue, context: context)

        return true
    }

    private func updateAccountBalance(account: AccountModel, amount: Double, context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<AccountModel>()
            let accounts = try context.fetch(descriptor)

            if let matchedAccount = accounts.first(where: { $0.id == account.id }) {
                matchedAccount.balance += amount
            }
        } catch {
            print("Failed to update balance: \(error)")
        }
    }

    private func validateInputs() -> Bool {
        guard !title.isEmpty,
              let amountValue = Double(amount),
              amountValue > 0,
              selectedAccount != nil else {
            return false
        }
        return true
    }

    func validateAccountExistence(context: ModelContext) -> Bool {
        do {
            let descriptor = FetchDescriptor<AccountModel>()
            let allAccounts = try context.fetch(descriptor)
            return !allAccounts.isEmpty
        } catch {
            print("Error checking accounts: \(error)")
            return false
        }
    }

    func reset() {
        title = ""
        amount = ""
        category = .salary
        date = Date()
        selectedAccount = nil
    }
}
