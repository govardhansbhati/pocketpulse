//
//  MockData.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//

import Foundation
import SwiftUI
import SwiftData

struct MockData {
    static let accounts: [AccountModel] = {
        let acc1 = AccountModel(name: "Savings",
                                type: .savings,
                                balance: 25_000,
                                institution: "SBI",
                                orderIndex: 0)
        let acc2 = AccountModel(name: "Checking",
                                type: .savings,
                                balance: 12_000,
                                institution: "HDFC",
                                orderIndex: 1)
        return [acc1, acc2]
    }()

    static let cards: [CardModel] = {
        let credit = CardModel(cardHolderName: "John Doe",
                               last4Digits: "1234",
                               expiryDate: "12/30",
                               providerType: .visa,
                               cardType: .credit,
                               cardDesign: .black,
                               bankName: "HDFC",
                               orderIndex: 0)
        let debit = CardModel(cardHolderName: "John Doe",
                              last4Digits: "5678",
                              expiryDate: "06/28",
                              providerType: .masterCard,
                              cardType: .debit,
                              cardDesign: .orange,
                              bankName: "SBI",
                              orderIndex: 1)
        return [credit, debit]
    }()

    static let transactions: [TransactionModel] = {
        let t1 = TransactionModel(title: "Groceries",
                                  amount: 1500,
                                  type: .expense,
                                  category: .food,
                                  date: .now.addingTimeInterval(-3600))
        let t2 = TransactionModel(title: "Salary",
                                  amount: 50_000, type: .income,
                                  category: .salary,
                                  date: .now.addingTimeInterval(-86_400))
        let t3 = TransactionModel(title: "Movie",
                                  amount: 450,
                                  type: .expense,
                                  category: .entertainment,
                                  date: .now.addingTimeInterval(-172_800))
        return [t1, t2, t3]
    }()
}
