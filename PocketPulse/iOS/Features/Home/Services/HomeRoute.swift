//
//  HomeRoute.swift
//  PocketPulse
//
//  Created by govardhan singh on 19/03/25.
//


import SwiftUI
import UIKit

enum HomeRoute: Hashable {
    // Cases for pushing views onto the stack
    case transactionList
    case allCards
    case profile
    case notification

    // The destination builder for pushed views
    @ViewBuilder
    var destination: some View {
        switch self {
        case .transactionList:
            TransactionListView()
        case .allCards:
            // Placeholder for the full card list view
            Text("All Cards View").navigationTitle("All Cards")
        case .profile:
            ProfileView() // Assuming you have this view
        case .notification:
            NotificationView() // Assuming you have this view
        }
    }
    
    // Defines sheets that can be presented from the Home screen
    enum Sheet: String, Identifiable {
        case addCard
        var id: String { self.rawValue }
    }
}
