//
//  DeletionAlert.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 24/08/25.
//

import SwiftUI
import SwiftData

// MARK: - Generic Deletion Alert
/// An enum to define the type of item being deleted.
/// This allows the alert to show a specific, context-aware message.
enum DeletableItemType {
    case transaction(title: String)
    case account(name: String)
    case card(name: String)
    case bill(title: String)
    case borrowLend(name: String)
    
    /// The title for the alert, based on the item type.
    var alertTitle: String {
        switch self {
        case .transaction: return "Delete Transaction?"
        case .account: return "Delete Account?"
        case .card: return "Delete Card?"
        case .bill: return "Delete Bill?"
        case .borrowLend: return "Delete Entry?"
        }
    }
    
    /// The detailed message for the alert, warning the user about the action.
    var alertMessage: String {
        switch self {
        case .transaction(let title):
            return "Are you sure you want to delete the transaction for \"\(title)\"? This action cannot be undone."
        case .account(let name):
            return "Are you sure you want to delete the account named \"\(name)\"? All associated data will be lost."
        case .card(let name):
            return "Are you sure you want to delete the card for \"\(name)\"?"
        case .bill(let title):
            return "Are you sure you want to delete the bill for \"\(title)\"?"
        case .borrowLend(let name):
            return "Are you sure you want to delete the entry for \"\(name)\"?"
        }
    }
}

/// A generic view modifier for presenting a deletion confirmation alert.
/// It uses a callback closure to let the calling view handle the actual deletion logic.
struct DeletionAlert<T: Identifiable>: ViewModifier {
    /// A binding to the optional item that the view wants to delete.
    @Binding var itemToDelete: T?
    /// The specific type of item, used to configure the alert's title and message.
    let itemType: DeletableItemType
    
    /// A closure that is executed when the user confirms the deletion.
    /// The view that uses this modifier is responsible for providing the deletion logic.
    let onDelete: (T) -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(
                itemType.alertTitle,
                isPresented: .constant(itemToDelete != nil),
                presenting: itemToDelete
            ) { item in
                Button("Delete", role: .destructive) {
                    onDelete(item)
                    itemToDelete = nil
                }
                Button("Cancel", role: .cancel) { itemToDelete = nil }
            } message: { _ in
                Text(itemType.alertMessage)
            }
    }
}

/// An extension on `View` to make applying the `DeletionAlert` modifier cleaner.
extension View {
    /// Applies a modifier to the view that presents a standardized deletion confirmation alert.
    /// - Parameters:
    ///   - for: A binding to the optional item that should be deleted.
    ///   - ofType: The `DeletableItemType` used to configure the alert's title and message.
    ///   - onDelete: A closure that contains the specific logic to execute upon deletion.
    func deletionAlert<T: Identifiable>(
        for item: Binding<T?>,
        ofType type: DeletableItemType,
        onDelete: @escaping (T) -> Void
    ) -> some View {
        self.modifier(DeletionAlert(itemToDelete: item, itemType: type, onDelete: onDelete))
    }
}
