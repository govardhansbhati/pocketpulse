//
//  BillUseCaseTests.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

@testable import PocketPulse
import Foundation
import Testing

@Suite("Bill Use Case Tests")
struct BillUseCaseTests {
    let billService: MockBillService
    let cardsService: MockCardsService
    let useCase: BillUseCase
    
    init() {
        self.billService = MockBillService()
        self.cardsService = MockCardsService()
        self.useCase = BillUseCase(billService: billService, cardsService: cardsService)
    }
    
    @Test("Add Bill")
    func addBill() async throws {
        // Given
        let bill = BillModel(title: "New Bill", amount: 200, dueDate: Date())
        let initialCount = try await billService.fetchBills().count
        
        // When
        try await useCase.addBill(bill)
        
        // Then
        let bills = try await billService.fetchBills()
        #expect(bills.count == initialCount + 1)
        #expect(bills.last?.title == "New Bill")
    }
    
    @Test("Add Borrow/Lend Item")
    func addBorrowLend() async throws {
        // Given
        let item = BorrowLendModel(name: "Friend", amount: 50, contact: "123", type: .borrowed, dueDate: Date())
        let initialCount = try await billService.fetchBorrowLendItems().count
        
        // When
        try await useCase.addBorrowLend(item)
        
        // Then
        let items = try await billService.fetchBorrowLendItems()
        #expect(items.count == initialCount + 1)
        #expect(items.last?.name == "Friend")
    }
}
