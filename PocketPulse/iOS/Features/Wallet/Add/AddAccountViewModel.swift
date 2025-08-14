//
//  AddAccountViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//


import Foundation
import SwiftUI
import SwiftData

// MARK: - Add Account ViewModel (Updated)
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
    func save(context: ModelContext) -> Result<Void, ValidationError> {
        guard !accountName.isEmpty else {
            return .failure(.missingTitle(field: "Account Nickname"))
        }
        guard let balanceValue = Double(initialBalance), balanceValue >= 0 else {
            return .failure(.invalidAmount)
        }
        
        // For bank accounts, institution is required.
        if accountType != .cash && institution.isEmpty {
            return .failure(.missingTitle(field: "Institution"))
        }

        let newAccount = AccountModel(
            name: accountName,
            type: accountType,
            balance: balanceValue,
            institution: accountType == .cash ? "Cash" : institution,
            accountNumber: accountNumber.isEmpty ? nil : accountNumber,
            ifscCode: ifscCode.isEmpty ? nil : ifscCode,
            openingDate: openingDate,
            status: status,
            notes: notes.isEmpty ? nil : notes
        )

        context.insert(newAccount)
        return .success(())
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



enum AccountStatus: String, Codable, CaseIterable, Identifiable {
    case active = "Active"
    case inactive = "Inactive"
    case closed = "Closed"
    case frozen = "Frozen"

    var id: String { self.rawValue }
}

// This enum focuses only on where money is held.
enum AccountType: String, Codable, CaseIterable, Identifiable {
    case savings
    case current
    case cash // For tracking physical cash in your wallet
    
    var id: String { self.rawValue }
}
