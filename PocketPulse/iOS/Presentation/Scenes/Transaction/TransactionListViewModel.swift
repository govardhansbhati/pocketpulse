//
//  TransactionListViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation
import SwiftData

@MainActor
final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [TransactionModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let useCase: TransactionUseCaseProtocol
    // We still need the service to fetch all transactions if not provided or if we want to rely on the use case for fetching too.
    // However, the existing view uses @Query. To fully refactor to MVVM, we should fetch data in the ViewModel.
    // But for now, to support 'delete', we at least need the use case.
    // If the view continues to use @Query, the ViewModel might only handle actions.
    // Ideally, we move fetching to ViewModel too.
    private let transactionsService: TransactionsServiceProtocol 
    
    init(useCase: TransactionUseCaseProtocol, transactionsService: TransactionsServiceProtocol) {
        self.useCase = useCase
        self.transactionsService = transactionsService
    }
    
    func loadTransactions() async {
        isLoading = true
        do {
            transactions = try await transactionsService.fetchTransactions()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func delete(transaction: TransactionModel) async {
        do {
            try await useCase.delete(transaction: transaction)
            await loadTransactions() // Refresh list
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
