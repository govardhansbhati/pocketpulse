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
    // MARK: - Input Properties
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var category: TransactionCategory = .other
    @Published var type: TransactionType = .expense
    @Published var date: Date = .now
    @Published var selectedAccount: AccountModel?

    // MARK: - Add Transaction
    func addTransaction(context: ModelContext) -> Bool {
        guard validateInputs(),
              let amountValue = Double(amount),
              let selectedAccount = selectedAccount else {
            return false
        }

        let newTransaction = TransactionModel(
            title: title,
            amount: amountValue,
            type: type,
            category: category,
            date: date,
            linkedAccountID: selectedAccount.id
        )

        context.insert(newTransaction)
        selectedAccount.balance -= amountValue

        return true
    }

    // MARK: - Input Validation
    private func validateInputs() -> Bool {
        guard !title.isEmpty,
              let amountValue = Double(amount),
              amountValue > 0,
              selectedAccount != nil else {
            return false
        }
        return true
    }

    // MARK: - Update Account Balance
    private func updateAccountBalance(account: AccountModel, amount: Double) {
        
        
    }

    // MARK: - Validate Account Type Requirement
    func validateAccountSelection(context: ModelContext) -> Bool {
        guard let selected = selectedAccount else { return false }

        do {
            let descriptor = FetchDescriptor<AccountModel>()
            let allAccounts = try context.fetch(descriptor)

            switch selected.type {
            case .card:
                let cards = allAccounts.filter { $0.type == AccountType.card }
                return !cards.isEmpty
            case .bank:
                let banks = allAccounts.filter { $0.type == AccountType.bank }
                return !banks.isEmpty
            default:
                return true
            }
        } catch {
            print("Error validating account type: \(error)")
            return false
        }
    }

    // MARK: - Reset Form Fields
    func reset() {
        title = ""
        amount = ""
        category = .other
        type = .expense
        date = Date()
        selectedAccount = nil
    }
}
