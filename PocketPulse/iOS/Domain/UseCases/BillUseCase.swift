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
    func addBill(_ bill: BillModel) async throws
    func updateBill(_ bill: BillModel) async throws
    func deleteBill(_ bill: BillModel) async throws
    
    func addBorrowLend(_ item: BorrowLendModel) async throws
    func updateBorrowLend(_ item: BorrowLendModel) async throws
    func deleteBorrowLend(_ item: BorrowLendModel) async throws
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
    
    func addBill(_ bill: BillModel) async throws {
        try await billService.add(bill)
    }
    
    func updateBill(_ bill: BillModel) async throws {
        try await billService.update(bill)
    }
    
    func deleteBill(_ bill: BillModel) async throws {
        try await billService.delete(bill)
    }
    
    func addBorrowLend(_ item: BorrowLendModel) async throws {
        try await billService.add(item)
    }
    
    func updateBorrowLend(_ item: BorrowLendModel) async throws {
        try await billService.update(item)
    }
    
    func deleteBorrowLend(_ item: BorrowLendModel) async throws {
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
            
            if let day = todayComponents.day, day > paymentDay {
                if todayComponents.month == 12 {
                    todayComponents.month = 1
                    todayComponents.year = (todayComponents.year ?? 0) + 1
                } else {
                    todayComponents.month = (todayComponents.month ?? 0) + 1
                }
            }
            
            let dueDateComponents = DateComponents(year: todayComponents.year,
                                                   month: todayComponents.month,
                                                   day: paymentDay)
            guard let nextDueDate = calendar.date(from: dueDateComponents) else { return nil }
            
            return BillModel(
                title: "\(card.bankName) Credit Card",
                amount: outstandingBalance,
                dueDate: nextDueDate
            )
        }
    }
}
