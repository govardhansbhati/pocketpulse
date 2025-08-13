//
//  BillViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

// MARK: - Bill ViewModel
@MainActor
class BillViewModel: ObservableObject {
    @Published var combinedBills: [BillModel] = []
    @Published var borrowLendItems: [BorrowLendModel] = []

    func update(manualBills: [BillModel], cards: [CardModel], borrowLendItems: [BorrowLendModel]) {
        // Generate automatic bills from the latest card data
        let creditCardBills = generateCreditCardBills(from: cards)
        
        // Combine and sort the lists
        self.combinedBills = (manualBills + creditCardBills).sorted { $0.dueDate < $1.dueDate }
        self.borrowLendItems = borrowLendItems
    }

    private func generateCreditCardBills(from cards: [CardModel]) -> [BillModel] {
        let calendar = Calendar.current
        let today = Date()
        let creditCards = cards.filter { $0.cardType == .credit && $0.paymentDueDate != nil }
        
        return creditCards.compactMap { card -> BillModel? in
            guard let paymentDay = card.paymentDueDate else {
                return nil
            }
            
            // Use the outstanding balance, or default to 0 if it's nil.
            let outstandingBalance = card.outstandingBalance ?? 0
            
            var todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            // If today's day is past the payment day, the due date is next month.
            if todayComponents.day! > paymentDay {
                if todayComponents.month == 12 {
                    todayComponents.month = 1
                    todayComponents.year! += 1
                } else {
                    todayComponents.month! += 1
                }
            }
            
            let dueDateComponents = DateComponents(year: todayComponents.year, month: todayComponents.month, day: paymentDay)
            guard let nextDueDate = calendar.date(from: dueDateComponents) else {
                return nil
            }

            return BillModel(
                title: "\(card.bankName) Credit Card",
                amount: outstandingBalance, // This will be 0 for new cards, which is correct.
                dueDate: nextDueDate
            )
        }
    }
}
