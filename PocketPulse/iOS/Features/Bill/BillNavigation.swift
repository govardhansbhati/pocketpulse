//
//  BillNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI
import UIKit

// MARK: - Bill Navigation
struct BillNavigationStack: View {
    @State private var path = NavigationPath()
    @State private var presentingSheet: BillRoute.Sheet?

    var body: some View {
        NavigationStack(path: $path) {
            BillView()
                .navigationDestination(for: BillRoute.self) { route in
                    route.destination
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $presentingSheet) { sheet in
            switch sheet {
            case .addBill:
                AddBillSheet()
            case .addBorrowLend:
                AddBorrowLendSheet()
            }
        }
        .environment(\.navigateBill, NavigateAction { route in
            path.append(route)
        })
        
        .environment(\.presentBillSheet, PresentSheetAction { sheet in
            presentingSheet = sheet
        })
    }
}

enum BillRoute: Hashable {
    case billDetail(id: UUID)
    case borrowLendDetail(id: UUID)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .billDetail(let id):
            Text("Details for bill \(id)").navigationTitle("Bill Details")
        case .borrowLendDetail(let id):
            Text("Details for item \(id)").navigationTitle("Entry Details")
        }
    }
    
    enum Sheet: String, Identifiable {
        case addBill
        case addBorrowLend
        var id: String { self.rawValue }
    }
}
