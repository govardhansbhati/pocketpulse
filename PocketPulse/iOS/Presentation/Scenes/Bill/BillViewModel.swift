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
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func delete(_ item: any PersistentModel) {
        Task {
            do {
                try await useCase.delete(item)
                await load()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
