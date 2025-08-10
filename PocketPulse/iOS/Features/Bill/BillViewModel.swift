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

    func fetchData(context: ModelContext) {
        do {
            // Fetch manual bills
            let manualBills = try context.fetch(FetchDescriptor<BillModel>(sortBy: [SortDescriptor(\.dueDate)]))
            
            // Generate automatic credit card bills
            let allCards = try context.fetch(FetchDescriptor<CardModel>())
            let creditCardBills = generateCreditCardBills(from: allCards)
            
            // Combine and sort the bills list
            self.combinedBills = (manualBills + creditCardBills).sorted { $0.dueDate < $1.dueDate }
            
            // --- NEW: Fetch borrow/lend items ---
            let borrowLendDescriptor = FetchDescriptor<BorrowLendModel>(sortBy: [SortDescriptor(\.name)])
            self.borrowLendItems = try context.fetch(borrowLendDescriptor)
            
        } catch {
            print("Failed to fetch bill data: \(error)")
        }
    }

    private func generateCreditCardBills(from cards: [CardModel]) -> [BillModel] {
        let calendar = Calendar.current
        let today = Date()
        let creditCards = cards.filter { $0.cardType == .credit && $0.paymentDueDate != nil }
        
        return creditCards.compactMap { card -> BillModel? in
            guard let paymentDay = card.paymentDueDate,
                  let outstandingBalance = card.outstandingBalance,
                  outstandingBalance > 0 else {
                return nil
            }
            
            var todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            if todayComponents.day! > paymentDay {
                if todayComponents.month == 12 {
                    todayComponents.month = 1
                    todayComponents.year! += 1
                } else {
                    todayComponents.month! += 1
                }
            }
            
            var dueDateComponents = DateComponents(year: todayComponents.year, month: todayComponents.month, day: paymentDay)
            guard let nextDueDate = calendar.date(from: dueDateComponents) else {
                return nil
            }

            return BillModel(
                title: "\(card.bankName) Credit Card",
                amount: outstandingBalance,
                dueDate: nextDueDate
            )
        }
    }
}
