//
//  AddAccountViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//


import Foundation
import SwiftUI
import SwiftData

// MARK: - Add/Edit Account Sheet & ViewModel
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
    
    private var accountToEdit: AccountModel?
    var isEditing: Bool { accountToEdit != nil }

    // Populates the form for editing an existing account.
    func setup(for account: AccountModel?) {
        guard let account = account else { return }
        self.accountToEdit = account
        
        accountName = account.name
        accountType = account.type
        initialBalance = String(account.balance)
        institution = account.institution
        accountNumber = account.accountNumber ?? ""
        ifscCode = account.ifscCode ?? ""
        openingDate = account.openingDate
        status = account.status
        notes = account.notes ?? ""
    }

    // Saves changes to an existing account or creates a new one.
    func save(context: ModelContext) -> Result<Void, ValidationError> {
        guard !accountName.isEmpty else {
            return .failure(.missingTitle(field: "Account Nickname"))
        }
        guard let balanceValue = Double(initialBalance), balanceValue >= 0 else {
            return .failure(.invalidAmount)
        }
        if accountType != .cash && institution.isEmpty {
            return .failure(.missingTitle(field: "Institution"))
        }

        // If editing, use the existing account; otherwise, create a new one.
        let account = accountToEdit ?? AccountModel(name: "", type: .savings, balance: 0, institution: "")
        
        account.name = accountName
        account.type = accountType
        account.balance = balanceValue
        account.institution = accountType == .cash ? "Cash" : institution
        account.accountNumber = accountNumber.isEmpty ? nil : accountNumber
        account.ifscCode = ifscCode.isEmpty ? nil : ifscCode
        account.openingDate = openingDate
        account.status = status
        account.notes = notes.isEmpty ? nil : notes

        if !isEditing {
            context.insert(account)
        }
        
        return .success(())
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
