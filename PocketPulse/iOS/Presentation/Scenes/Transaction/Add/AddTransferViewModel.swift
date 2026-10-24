//
//  AddTransferViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/10/26.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class AddTransferViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var date: Date = .now
    @Published var selectedFromAccount: AccountModel? {
        didSet {
            // Automatically clear or adjust to-account if it conflicts with from-account
            if selectedToAccount?.id == selectedFromAccount?.id {
                selectedToAccount = availableToAccounts.first
            }
        }
    }
    @Published var selectedToAccount: AccountModel?
    @Published var accounts: [AccountModel] = []
    
    var availableToAccounts: [AccountModel] {
        guard let from = selectedFromAccount else { return accounts }
        return accounts.filter { $0.id != from.id }
    }
    
    private let transactionUseCase: TransactionUseCaseProtocol
    private let accountUseCase: AccountUseCaseProtocol
    private let dataUpdateService: DataUpdateServiceProtocol
    
    init(
        transactionUseCase: TransactionUseCaseProtocol,
        accountUseCase: AccountUseCaseProtocol,
        dataUpdateService: DataUpdateServiceProtocol,
        initialTitle: String = "",
        initialAmount: String = "",
        initialDate: Date = .now
    ) {
        self.transactionUseCase = transactionUseCase
        self.accountUseCase = accountUseCase
        self.dataUpdateService = dataUpdateService
        self.title = initialTitle
        self.amount = initialAmount
        self.date = initialDate
    }
    
    func fetchData() async {
        do {
            self.accounts = try await accountUseCase.fetchAccounts()
            if selectedFromAccount == nil {
                selectedFromAccount = accounts.first
            }
            if selectedToAccount == nil {
                selectedToAccount = availableToAccounts.first
            }
        } catch {
            print("Error fetching accounts for transfer: \(error)")
        }
    }
    
    func saveTransfer() async -> Result<Void, ValidationError> {
        guard let amountValue = Double(amount), amountValue > 0 else {
            return .failure(.invalidAmount)
        }
        guard let fromAccount = selectedFromAccount else {
            return .failure(.missingAccount)
        }
        guard let toAccount = selectedToAccount else {
            return .failure(.missingDestinationAccount)
        }
        guard fromAccount.id != toAccount.id else {
            return .failure(.sameTransferAccount)
        }
        guard fromAccount.balance >= amountValue else {
            return .failure(.insufficientFunds(accountName: fromAccount.name))
        }
        
        let finalTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "\(fromAccount.name) → \(toAccount.name)"
            : title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let transaction = TransactionModel(
            title: finalTitle,
            amount: amountValue,
            type: .transfer,
            category: .transfer,
            date: date,
            linkedAccountID: fromAccount.id,
            destinationAccountID: toAccount.id
        )
        
        do {
            try await transactionUseCase.add(transaction: transaction)
            dataUpdateService.notifyTransactionUpdated()
            dataUpdateService.notifyWalletUpdated()
            return .success(())
        } catch {
            return .failure(.custom(message: "Failed to save transfer: \(error.localizedDescription)"))
        }
    }
}
