// swiftlint:disable function_body_length
//
//  MockDataSeeder.swift
//  PocketPulse
//
//  Created by Govardhan Singh on 18/01/26.
//

import Foundation
import SwiftData
import SwiftUI

/// Handles the seeding of mock data for Demo Mode.
@MainActor
final class MockDataSeeder {
    /// Populates the given context with mock data.
    /// - Parameter context: The ModelContext to seed.
    static func seed(context: ModelContext) {
        // --- Accounts ---
        let savingsAccount = AccountModel(
            name: "HDFC Savings",
            type: .savings,
            balance: 125000.0,
            institution: "HDFC Bank",
            accountNumber: "xxxx-xxxx-4589",
            ifscCode: "HDFC0001234",
            openingDate: Date().addingTimeInterval(-86400 * 365), // 1 year ago
            orderIndex: 0
        )
        
        let walletAccount = AccountModel(
            name: "Pocket Cash",
            type: .wallet,
            balance: 5000.0,
            institution: "Cash",
            orderIndex: 1
        )
        
        let sbiAccount = AccountModel(
            name: "SBI Current",
            type: .current,
            balance: 45000.0,
            institution: "SBI",
            accountNumber: "xxxx-xxxx-9988",
            ifscCode: "SBIN0001234",
            openingDate: Date().addingTimeInterval(-86400 * 730), // 2 years ago
            orderIndex: 2
        )
        
        let emergencyFund = AccountModel(
            name: "Emergency Fund",
            type: .savings,
            balance: 200000.0,
            institution: "ICICI Bank",
            orderIndex: 3
        )

        context.insert(savingsAccount)
        context.insert(walletAccount)
        context.insert(sbiAccount)
        context.insert(emergencyFund)
        
        // --- Cards ---
        // Corrected Init:
        // init(cardHolderName, last4Digits, expiryDate, providerType, cardType, cardDesign, bankName, orderIndex, ...)
        
        let creditCard = CardModel(
            cardHolderName: "Govardhan Singh",
            last4Digits: "6789",
            expiryDate: "12/28",
            providerType: .masterCard,
            cardType: .credit,
            cardDesign: .black,
            bankName: "HDFC Bank",
            orderIndex: 0,
            linkedBankAccount: savingsAccount,
            creditLimit: 100000.0,
            outstandingBalance: 15450.0,
            billingDate: 15,
            paymentDueDate: 5,
            status: .active
        )
        
        let debitCard = CardModel(
            cardHolderName: "Govardhan Singh",
            last4Digits: "1234",
            expiryDate: "09/27",
            providerType: .visa,
            cardType: .debit,
            cardDesign: .orange,
            bankName: "SBI",
            orderIndex: 1,
            linkedBankAccount: sbiAccount,
            status: .active
        )
        
        context.insert(creditCard)
        context.insert(debitCard)
        
        // --- Transactions ---
        let pastDate = { (days: Double) in Date().addingTimeInterval(-86400 * days) }
        
        let salaryTxn = TransactionModel(
            title: "Salary Dec",
            amount: 85000.0,
            type: .income,
            category: .salary,
            date: pastDate(5),
            linkedAccountID: savingsAccount.id
        )
        
        let rentTxn = TransactionModel(
            title: "Rent Payment",
            amount: 25000.0,
            type: .expense,
            category: .rent,
            date: pastDate(4),
            linkedAccountID: savingsAccount.id
        )
        
        let groceryTxn = TransactionModel(
            title: "BigBasket",
            amount: 3450.0,
            type: .expense,
            category: .food,
            date: pastDate(2),
            linkedCardID: creditCard.id
        )
        
        let netflix = TransactionModel(
            title: "Netflix Subscription",
            amount: 649.0,
            type: .expense,
            category: .entertainment,
            date: pastDate(10),
            linkedCardID: creditCard.id
        )
        
        let fuel = TransactionModel(
            title: "Shell Fuel",
            amount: 2500.0,
            type: .expense,
            category: .transport,
            date: pastDate(1),
            linkedCardID: debitCard.id
        )
        
        let dinner = TransactionModel(
            title: "Dinner at Taj",
            amount: 4500.0,
            type: .expense,
            category: .food,
            date: pastDate(3),
            linkedCardID: creditCard.id
        )
        
        let freelance = TransactionModel(
            title: "Freelance Project",
            amount: 15000.0,
            type: .income,
            category: .freelance,
            date: pastDate(15),
            linkedAccountID: sbiAccount.id
        )
        
        context.insert(salaryTxn)
        context.insert(rentTxn)
        context.insert(groceryTxn)
        context.insert(netflix)
        context.insert(fuel)
        context.insert(dinner)
        context.insert(freelance)
        
        // --- Bills ---
        let internetBill = BillModel(
            title: "FiberNet Internet",
            amount: 999.0,
            dueDate: Date().addingTimeInterval(86400 * 5), // Due in 5 days
            isPaid: false,
            reminderEnabled: true,
            reminder: .oneDayBefore
        )
        
        let electricityBill = BillModel(
            title: "Electricity Bill",
            amount: 1250.0,
            dueDate: Date().addingTimeInterval(86400 * 10), // Due in 10 days
            isPaid: false,
            reminderEnabled: true,
            reminder: .twoDaysBefore
        )
        
        let creditCardBill = BillModel(
            title: "HDFC Credit Card Bill",
            amount: 15450.0,
            dueDate: Date().addingTimeInterval(86400 * 2), // Due in 2 days
            isPaid: false,
            reminderEnabled: true,
            reminder: .oneDayBefore
        )
        
        context.insert(internetBill)
        context.insert(electricityBill)
        context.insert(creditCardBill)
        
        do {
            try context.save()
            print("Successfully seeded mock data for Demo Mode.")
        } catch {
            print("Failed to save mock data: \(error)")
        }
    }
}
// swiftlint:enable function_body_length
