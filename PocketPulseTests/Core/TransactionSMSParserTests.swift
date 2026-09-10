//
//  TransactionSMSParserTests.swift
//  PocketPulseTests
//
//  Created by govardhan singh on 08/09/26.
//

@testable import PocketPulse
import XCTest

final class TransactionSMSParserTests: XCTestCase {
    
    // MARK: - Debit / Expense Tests
    
    func testParseHDFCBankDebitSMS() {
        let text = "HDFC Bank Alert: A/c *1234 debited for Rs 450.00 on 08-Sep-26 at STARBUCKS. Avl Bal: INR 12,450.00"
        let result = TransactionSMSParser.parse(text: text)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.amount, 450.00)
        XCTAssertEqual(result?.type, .expense)
        XCTAssertEqual(result?.category, .food)
        XCTAssertTrue(result?.title.contains("Starbucks") ?? false)
        XCTAssertEqual(result?.accountHint, "HDFC (••1234)")
    }
    
    func testParseICICICreditCardSMS() {
        let text = "Dear Customer, INR 1,499.00 spent on your ICICI Card ending with 4321 at AMAZON on 08-Sep-26."
        let result = TransactionSMSParser.parse(text: text)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.amount, 1499.00)
        XCTAssertEqual(result?.type, .expense)
        XCTAssertEqual(result?.category, .shopping)
        XCTAssertTrue(result?.title.contains("Amazon") ?? false)
        XCTAssertEqual(result?.accountHint, "ICICI (••4321)")
    }
    
    func testParseUPISwiggyPayment() {
        let text = "Paid Rs.250.00 to SWIGGY via UPI ref 425612345678. Avl Bal Rs. 8420."
        let result = TransactionSMSParser.parse(text: text)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.amount, 250.00)
        XCTAssertEqual(result?.type, .expense)
        XCTAssertEqual(result?.category, .food)
        XCTAssertTrue(result?.title.contains("Swiggy") ?? false)
    }
    
    func testParseUberTransportPayment() {
        let text = "Your SBI A/c ending 8765 is debited by Rs.1200.00 on 08-Sep-26 transfer to Uber."
        let result = TransactionSMSParser.parse(text: text)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.amount, 1200.00)
        XCTAssertEqual(result?.type, .expense)
        XCTAssertEqual(result?.category, .transport)
        XCTAssertTrue(result?.title.contains("Uber") ?? false)
        XCTAssertEqual(result?.accountHint, "SBI (••8765)")
    }
    
    func testParseUSDInternationalPayment() {
        let text = "Charged $45.50 at Whole Foods on your Chase Visa card."
        let result = TransactionSMSParser.parse(text: text)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.amount, 45.50)
        XCTAssertEqual(result?.type, .expense)
        XCTAssertEqual(result?.category, .food)
    }
    
    // MARK: - Credit / Income Tests
    
    func testParseSalaryCredit() {
        let text = "A/c *5678 credited with INR 75,000.00 on 01-Sep-26 by Salary. Avl Bal: INR 82,300.00"
        let result = TransactionSMSParser.parse(text: text)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.amount, 75000.00)
        XCTAssertEqual(result?.type, .income)
        XCTAssertEqual(result?.category, .salary)
    }
    
    func testParseRefundCredit() {
        let text = "Your account *9876 has been credited with Rs 499.00 refund from Flipkart."
        let result = TransactionSMSParser.parse(text: text)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.amount, 499.00)
        XCTAssertEqual(result?.type, .income)
    }
    
    // MARK: - Safety & Filter Tests
    
    func testIgnorePureOTPMessage() {
        let otpText = "Your OTP for login to your HDFC Bank NetBanking is 492018. Do not share with anyone."
        let result = TransactionSMSParser.parse(text: otpText)
        
        XCTAssertNil(result, "Parser should ignore pure OTP security messages")
    }
    
    func testIgnoreNonFinancialMessage() {
        let randomText = "Hey, are we still meeting today at Starbucks?"
        let result = TransactionSMSParser.parse(text: randomText)
        
        XCTAssertNil(result, "Parser should ignore random text without financial triggers and amounts")
    }
}
