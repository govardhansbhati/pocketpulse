//
//  BillViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

// MARK: - Bill ViewModel
/// Manages the state and business logic for the main `BillView`.
///
/// This ViewModel is responsible for fetching all relevant data (manual bills, cards, borrow/lend items)
/// and processing it into a format that the view can easily display. It's designed to be updated
/// reactively whenever the underlying SwiftData queries in the `BillView` change.
@MainActor
class BillViewModel: ObservableObject {
    /// The final, sorted list of all upcoming bills, including both manual and automatic credit card reminders.
    @Published var combinedBills: [BillModel] = []
    /// The list of all borrow and lend items.
    @Published var borrowLendItems: [BorrowLendModel] = []

    /// Updates the ViewModel's published properties with the latest data from the view.
    /// This method is the central point for processing data for the Bills tab.
    /// - Parameters:
    ///   - manualBills: The array of `BillModel` objects fetched by the view's `@Query`.
    ///   - cards: The array of `CardModel` objects fetched by the view's `@Query`.
    ///   - borrowLendItems: The array of `BorrowLendModel` objects fetched by the view's `@Query`.
    func update(manualBills: [BillModel], cards: [CardModel], borrowLendItems: [BorrowLendModel]) {
        // Generate automatic bills from the latest card data.
        let creditCardBills = generateCreditCardBills(from: cards)
        
        // Combine the manually added bills with the automatic ones and sort them by due date.
        self.combinedBills = (manualBills + creditCardBills).sorted { $0.dueDate < $1.dueDate }
        
        // Update the borrow/lend items.
        self.borrowLendItems = borrowLendItems
    }

    /// Generates a list of upcoming `BillModel` instances in memory based on credit card data.
    /// It calculates the next payment due date for each credit card.
    /// - Parameter cards: An array of `CardModel` objects from the database.
    /// - Returns: An array of `BillModel` objects representing upcoming credit card payments.
    private func generateCreditCardBills(from cards: [CardModel]) -> [BillModel] {
        let calendar = Calendar.current
        let today = Date()
        
        // Filter for only credit cards that have a payment due date set.
        let creditCards = cards.filter { $0.cardType == .credit && $0.paymentDueDate != nil }
        
        return creditCards.compactMap { card -> BillModel? in
            guard let paymentDay = card.paymentDueDate else {
                return nil
            }
            
            // Use the outstanding balance, or default to 0 if it's nil.
            let outstandingBalance = card.outstandingBalance ?? 0
            
            var todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            // If today's day is past the payment day, the due date is for the next month.
            if todayComponents.day! > paymentDay {
                if todayComponents.month == 12 {
                    // Handle year rollover for December.
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

            // Create a BillModel instance in memory (it is not saved to SwiftData).
            return BillModel(
                title: "\(card.bankName) Credit Card",
                amount: outstandingBalance,
                dueDate: nextDueDate
            )
        }
    }
}
