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
@MainActor
class BillViewModel: ObservableObject {
    /// The final, sorted list of all upcoming bills, including both manual and automatic credit card reminders.
    @Published var combinedBills: [BillModel] = []
    /// The list of all borrow and lend items.
    @Published var borrowLendItems: [BorrowLendModel] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var totalUpcomingBills: Double = 0
    @Published var totalBorrowed: Double = 0
    @Published var totalLent: Double = 0
    
    private let useCase: BillUseCaseProtocol
    
    init(useCase: BillUseCaseProtocol) {
        self.useCase = useCase
    }
    
    /// Loads the latest data from the UseCase.
    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let summary = try await useCase.loadBillData()
            self.combinedBills = summary.combinedBills
            self.borrowLendItems = summary.borrowLendItems
            
            // Calculate Totals
            self.totalUpcomingBills = combinedBills.filter { !$0.isPaid }.reduce(0) { $0 + $1.amount }
            self.totalBorrowed = borrowLendItems.filter { $0.type == .borrowed }.reduce(0) { $0 + $1.amount }
            self.totalLent = borrowLendItems.filter { $0.type == .lent }.reduce(0) { $0 + $1.amount }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func delete(_ item: any PersistentModel) {
        Task {
            do {
                if let bill = item as? BillModel {
                    try await useCase.deleteBill(bill)
                } else if let borrowLend = item as? BorrowLendModel {
                    try await useCase.deleteBorrowLend(borrowLend)
                }
                await load()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
