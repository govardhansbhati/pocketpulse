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
    @Published var initialBalance = ""
    @Published var institution = ""
    @Published var accountNumber = ""
    @Published var ifscCode = ""
    @Published var openingDate: Date = .now
    @Published var status: AccountStatus = .active
    @Published var notes = ""

    // save function
    func save(context: ModelContext) -> Bool {
        guard !accountName.isEmpty,
              !institution.isEmpty,
              let balanceValue = Double(initialBalance),
              balanceValue >= 0 else {
            return false // Basic validation failed
        }

        let newAccount = AccountModel(
            name: accountName,
            type: accountType,
            balance: balanceValue,
            institution: institution,
            accountNumber: accountNumber.isEmpty ? nil : accountNumber, // Save as nil if empty
            ifscCode: ifscCode.isEmpty ? nil : ifscCode,
            openingDate: openingDate,
            status: status,
            notes: notes.isEmpty ? nil : notes
        )

        context.insert(newAccount)
        return true
    }

    // reset function
    func reset() {
        accountName = ""
        accountType = .savings
        initialBalance = ""
        institution = ""
        accountNumber = ""
        ifscCode = ""
        openingDate = .now
        status = .active
        notes = ""
    }
}
