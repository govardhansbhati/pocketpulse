//
//  TransactionDetectionManagerTests.swift
//  PocketPulseTests
//
//  Created by govardhan singh on 08/09/26.
//

@testable import PocketPulse
import XCTest

@MainActor
final class TransactionDetectionManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clean up test keys
        UserDefaults.standard.removeObject(forKey: "pocketpulse.pendingTransactions.queue")
        UserDefaults.standard.removeObject(forKey: "pocketpulse.pendingTransactions.dismissed")
        TransactionDetectionManager.shared.pendingTransactions = []
        TransactionDetectionManager.shared.activePromptTransaction = nil
    }
    
    func testAddDetectedTransaction() {
        let manager = TransactionDetectionManager.shared
        let item = DetectedTransaction(
            rawText: "HDFC debited 450",
            amount: 450.0,
            title: "Starbucks",
            type: .expense,
            category: .food,
            source: .clipboard
        )
        
        manager.addDetectedTransaction(item)
        
        XCTAssertEqual(manager.pendingTransactions.count, 1)
        XCTAssertEqual(manager.activePromptTransaction?.title, "Starbucks")
    }
    
    func testDeduplicationPreventsDuplicates() {
        let manager = TransactionDetectionManager.shared
        let item1 = DetectedTransaction(
            rawText: "HDFC debited 450",
            amount: 450.0,
            title: "Starbucks",
            type: .expense,
            category: .food,
            source: .clipboard
        )
        let item2 = DetectedTransaction(
            rawText: "HDFC debited 450 duplicate",
            amount: 450.0,
            title: "Starbucks",
            type: .expense,
            category: .food,
            source: .shortcut
        )
        
        manager.addDetectedTransaction(item1)
        manager.addDetectedTransaction(item2)
        
        XCTAssertEqual(manager.pendingTransactions.count, 1, "Duplicate content hash should not be added again")
    }
    
    func testDismissTransactionPromotesNext() {
        let manager = TransactionDetectionManager.shared
        let item1 = DetectedTransaction(
            rawText: "SMS 1",
            amount: 100.0,
            title: "Merchant 1",
            type: .expense,
            source: .clipboard
        )
        let item2 = DetectedTransaction(
            rawText: "SMS 2",
            amount: 200.0,
            title: "Merchant 2",
            type: .expense,
            source: .shortcut
        )
        
        manager.addDetectedTransaction(item1)
        manager.addDetectedTransaction(item2)
        
        XCTAssertEqual(manager.activePromptTransaction?.id, item1.id)
        
        manager.dismissTransaction(item1)
        
        XCTAssertEqual(manager.pendingTransactions.count, 1)
        XCTAssertEqual(manager.activePromptTransaction?.id, item2.id)
    }
}
