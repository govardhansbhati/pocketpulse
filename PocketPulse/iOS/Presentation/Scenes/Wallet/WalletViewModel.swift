//
//  WalletViewModel.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import SwiftUI
import SwiftData

@MainActor
class WalletViewModel: ObservableObject {
    @Published var accounts: [AccountModel] = []
    @Published var cards: [CardModel] = []
    
    @Published var isLoading: Bool = false
    @Published var alertInfo: AlertInfo?
    @Published var errorMessage: String?
    
    @Published var netWorth: Double = 0
    @Published var totalCreditLimit: Double = 0
    @Published var totalCreditUsed: Double = 0
    
    private let useCase: WalletUseCaseProtocol
    
    init(useCase: WalletUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func load() async {
        isLoading = true
        do {
            let summary = try await useCase.loadData()
            self.accounts = summary.accounts
            self.cards = summary.cards
            
            // Calculate Net Worth
            self.netWorth = accounts.reduce(0) { $0 + $1.balance }
            
            // Calculate Credit Summary
            let creditCards = cards.filter { $0.cardType == .credit }
            self.totalCreditLimit = creditCards.reduce(0) { $0 + ($1.creditLimit ?? 0) }
            self.totalCreditUsed = creditCards.reduce(0) { $0 + ($1.outstandingBalance ?? 0) }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func deleteAccount(_ account: AccountModel) {
        Task {
            do {
                try await useCase.deleteAccount(account)
                await load()
            } catch let error as WalletError {
                self.alertInfo = AlertInfo(title: AppStrings.Error.deletionFailed, message: error.localizedDescription)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func deleteCard(_ card: CardModel) {
        Task {
            do {
                try await useCase.deleteCard(card)
                await load()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func moveAccount(from source: IndexSet, to destination: Int) {
        var reorderedAccounts = accounts
        reorderedAccounts.move(fromOffsets: source, toOffset: destination)
        self.accounts = reorderedAccounts // Optimistic update
        
        Task {
            try? await useCase.updateAccountOrder(reorderedAccounts)
        }
    }
    
    func moveCard(from source: IndexSet, to destination: Int) {
        var reorderedCards = cards
        reorderedCards.move(fromOffsets: source, toOffset: destination)
        self.cards = reorderedCards // Optimistic update
        
        Task {
            try? await useCase.updateCardOrder(reorderedCards)
        }
    }
}
