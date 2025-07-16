//
//  AddCardViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//

import Foundation
import SwiftUI
import SwiftData

class AddCardViewModel: ObservableObject {
    @Published var cardHolderName: String = ""
    @Published var cardNumber: String = ""
    @Published var expiryDate: Date = .now
    @Published var providerType: CardProvider = .masterCard
    @Published var cardType: CardType = .credit
    @Published var cardDesign: CardDesign = .black
    @Published var balance: String = ""
    @Published var bankName: String = ""
    @Published var selectedBankAccount: AccountModel?

    func save(context: ModelContext) -> Bool {
        guard !cardHolderName.isEmpty,
              !cardNumber.isEmpty,
              !bankName.isEmpty,
              let balanceValue = Double(balance),
              balanceValue >= 0 else {
            return false
        }

        let newCard = CardModel(
            cardNumber: cardNumber,
            expiryDate: formattedDate(expiryDate),
            cardHolderName: cardHolderName,
            providerType: providerType,
            cardType: cardType,
            cardDesign: cardDesign,
            balance: balanceValue,
            bankName: bankName,
            linkedBankAccount: cardType == .debit ? selectedBankAccount : nil
        )

        context.insert(newCard)
        return true
    }

    func reset() {
        cardHolderName = ""
        cardNumber = ""
        expiryDate = .now
        providerType = .masterCard
        cardType = .credit
        cardDesign = .black
        balance = ""
        bankName = ""
        selectedBankAccount = nil
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: date)
    }
}
