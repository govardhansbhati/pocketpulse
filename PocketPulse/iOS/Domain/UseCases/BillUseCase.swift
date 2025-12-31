//
//  BillUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 31/12/25.
//

import Foundation
import SwiftData

struct BillSummary {
    let combinedBills: [BillModel]
    let borrowLendItems: [BorrowLendModel]
}

protocol BillUseCaseProtocol {
    func loadBillData() async throws -> BillSummary
    func delete(_ item: any PersistentModel) async throws
}

final class BillUseCase: BillUseCaseProtocol {
    private let billService: BillServiceProtocol
    private let cardsService: CardsServiceProtocol
    
    init(billService: BillServiceProtocol, cardsService: CardsServiceProtocol) {
        self.billService = billService
        self.cardsService = cardsService
    }
    
    func loadBillData() async throws -> BillSummary {
        // Fetch data concurrently
        async let manualBillsTask = billService.fetchBills()
        async let cardsTask = cardsService.fetchCards()
        async let borrowLendItemsTask = billService.fetchBorrowLendItems()
        
        let manualBills = try await manualBillsTask
        let cards = try await cardsTask
        let borrowLendItems = try await borrowLendItemsTask
        
        let creditCardBills = generateCreditCardBills(from: cards)
        let combinedBills = (manualBills + creditCardBills).sorted { $0.dueDate < $1.dueDate }
        
        return BillSummary(combinedBills: combinedBills, borrowLendItems: borrowLendItems)
    }
    
    func delete(_ item: any PersistentModel) async throws {
        try await billService.delete(item)
    }
    
    // Logic extracted from BillViewModel
    private func generateCreditCardBills(from cards: [CardModel]) -> [BillModel] {
        let calendar = Calendar.current
        let today = Date()
        
        let creditCards = cards.filter { $0.cardType == .credit && $0.paymentDueDate != nil }
        
        return creditCards.compactMap { card -> BillModel? in
            guard let paymentDay = card.paymentDueDate else { return nil }
            
            let outstandingBalance = card.outstandingBalance ?? 0
            var todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            if todayComponents.day! > paymentDay {
                if todayComponents.month == 12 {
                    todayComponents.month = 1
                    todayComponents.year! += 1
                } else {
                    todayComponents.month! += 1
                }
            }
            
            let dueDateComponents = DateComponents(year: todayComponents.year, month: todayComponents.month, day: paymentDay)
            guard let nextDueDate = calendar.date(from: dueDateComponents) else { return nil }
            
            return BillModel(
                title: "\(card.bankName) Credit Card",
                amount: outstandingBalance,
                dueDate: nextDueDate
            )
        }
    }
}
