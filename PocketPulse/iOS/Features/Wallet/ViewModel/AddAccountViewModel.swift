//
//  AddAccountViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//


import Foundation
import SwiftUI
import SwiftData

class AddAccountViewModel: ObservableObject {
    @Published var accountName = ""
    @Published var accountType: AccountType = .savings
    @Published var amount = ""
    @Published var details = ""

    func save(context: ModelContext) -> Bool {
        guard !accountName.isEmpty,
              let amountValue = Double(amount),
              amountValue >= 0 else {
            return false
        }

        let newAccount = AccountModel(
            name: accountName,
            type: accountType,
            balance: amountValue,
            details: details
        )

        context.insert(newAccount)
        return true
    }

    func reset() {
        accountName = ""
        accountType = .savings
        amount = ""
        details = ""
    }
}
