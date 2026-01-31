//
//  BillNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftData
import SwiftUI

// MARK: - Bill Navigation
/// A view that encapsulates the `NavigationStack` for the entire Bills feature.
/// It defines the possible navigation routes and manages the presentation of sheets.
struct BillNavigationStack: View {
    @Environment(\.modelContext) private var context
    /// The navigation path that holds the stack of pushed views.
    @State private var path = NavigationPath()
    /// A state variable to hold the sheet that should currently be presented.
    @State private var presentingSheet: BillRoute.Sheet?
    
    var body: some View {
        NavigationStack(path: $path) {
            BillFactory(context: context).makeBillView() // BillView is the root of this stack
                .navigationDestination(for: BillRoute.self) { route in
                    route.destination
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $presentingSheet) { sheet in
            // The view to present is determined by the `presentingSheet` state.
            // We inject dependencies here.
            switch sheet {
            case .addBill(let bill):
                let service = BillService(context: context)
                let cardsService = CardsService(context: context)
                let useCase = BillUseCase(billService: service, cardsService: cardsService)
                let viewModel = AddBillViewModel(useCase: useCase,
                                                 dataUpdateService: AppContainer.shared.makeDataUpdateService())
                AddBillSheet(viewModel: viewModel, billToEdit: bill, onSave: {
                    // Notification handled internally by ViewModel
                })
            case .addBorrowLend(let item):
                let service = BillService(context: context)
                let cardsService = CardsService(context: context)
                let useCase = BillUseCase(billService: service,
                                          cardsService: cardsService)
                let viewModel = AddBorrowLendViewModel(useCase: useCase,
                                                       dataUpdateService: AppContainer.shared.makeDataUpdateService())
                AddBorrowLendSheet(viewModel: viewModel, itemToEdit: item, onSave: {
                    // Notification handled internally by ViewModel
                })
            }
        }
        // Provide the navigation and sheet actions to the environment for child views to use.
        .environment(\.navigateBill, NavigateAction { route in
            path.append(route)
        })
        .environment(\.presentBillSheet, PresentSheetAction { sheet in
            presentingSheet = sheet
        })
    }
}

/// Defines all possible navigation destinations within the Bills feature.
enum BillRoute: Hashable {
    // Cases for pushing views onto the navigation stack
    case billDetail(BillModel)
    case borrowLendDetail(BorrowLendModel)
    
    /// A view builder that returns the correct destination view for a given route.
    @ViewBuilder
    var destination: some View {
        switch self {
        case .billDetail(let bill):
            BillDetailView(bill: bill)
        case .borrowLendDetail(let item):
            BorrowLendDetailView(item: item)
        }
    }
    
    /// An enum that defines the different sheets that can be presented from the Bills tab.
    /// It conforms to `Identifiable` so it can be used with the `.sheet(item:)` modifier.
    enum Sheet: Identifiable {
        case addBill(bill: BillModel?)
        case addBorrowLend(item: BorrowLendModel?)
        
        /// A stable, unique identifier for each sheet case.
        /// This is crucial for SwiftUI to correctly manage the sheet's presentation.
        var id: String {
            switch self {
            case .addBill(let bill):
                // If a bill exists, use its ID to make the sheet's ID unique for editing.
                // Otherwise, use a static string for adding a new bill.
                return "addBill_\(bill?.id.uuidString ?? "new")"
            case .addBorrowLend(let item):
                return "addBorrowLend_\(item?.id.uuidString ?? "new")"
            }
        }
    }
}
