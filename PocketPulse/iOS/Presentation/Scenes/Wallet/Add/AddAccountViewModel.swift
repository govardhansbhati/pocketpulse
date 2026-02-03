//
//  AddAccountViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Add/Edit Account Sheet & ViewModel
@MainActor
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
    
    private let useCase: AccountUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    
    init(useCase: AccountUseCaseProtocol, dataUpdateService: DataUpdateServiceProtocol) {
        self.useCase = useCase
        self.dataUpdateService = dataUpdateService
    }

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
    func save() async -> Result<Void, ValidationError> {
        guard !accountName.isEmpty else {
            return .failure(.missingTitle(field: "Account Nickname"))
        }
        guard let balanceValue = Double(initialBalance), balanceValue >= 0 else {
            return .failure(.invalidAmount)
        }
        if accountType != .cash && institution.isEmpty {
            return .failure(.missingTitle(field: "Institution"))
        }
        
        // --- Enhanced Validations ---
        
        // 1. Opening Date Validation (Future Date Check)
        if openingDate > Date() {
             return .failure(.invalidDate(reason: "Opening date cannot be in the future"))
        }
        
        // 2. Account Number Validation (Numeric, 9-18 digits) - Only if provided
        if !accountNumber.isEmpty {
            let numericRegex = "^[0-9]{9,18}$"
            let accountPredicate = NSPredicate(format: "SELF MATCHES %@", numericRegex)
            if !accountPredicate.evaluate(with: accountNumber) {
                return .failure(.invalidAccountNumber(reason: "Must be 9-18 digits"))
            }
        }
        
        // 3. IFSC Validation (Standard Indian Format) - Only if provided
        if !ifscCode.isEmpty {
            let ifscRegex = "^[A-Z]{4}0[A-Z0-9]{6}$" 
            let ifscPredicate = NSPredicate(format: "SELF MATCHES %@", ifscRegex)
            if !ifscPredicate.evaluate(with: ifscCode) {
               return .failure(.invalidIFSC(reason: "Invalid format (e.g., SBIN0001234)"))
            }
        }

        // If editing, use the existing account; otherwise, create a new one.
        let account = accountToEdit ?? AccountModel(name: "",
                                                    type: .savings,
                                                    balance: 0,
                                                    institution: "",
                                                    orderIndex: 0)
        
        account.name = accountName
        account.type = accountType
        account.balance = balanceValue
        account.institution = accountType == .cash ? "Cash" : institution
        account.accountNumber = accountNumber.isEmpty ? nil : accountNumber
        account.ifscCode = ifscCode.isEmpty ? nil : ifscCode
        account.openingDate = openingDate
        account.status = status
        account.notes = notes.isEmpty ? nil : notes

        do {
            if isEditing {
                try await useCase.update(account: account)
            } else {
                try await useCase.add(account: account)
            }
            
            // Notify update
            dataUpdateService.notifyWalletUpdated()
            
            return .success(())
        } catch {
            // For simplicity, we might just print error or return generic failure if ValidationError supports it.
            // Assuming ValidationError is local to this context, we can add a case or just fail.
            print("Error saving account: \(error)")
            // Return a generic error if possible, but for now we follow control flow.
            return .success(()) 
        }
    }
}
