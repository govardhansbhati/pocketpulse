//
//  AddBorrowLendViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

/// Manages the state and logic for the `AddBorrowLendSheet`.
class AddBorrowLendViewModel: ObservableObject {
    @Published var name = ""
    @Published var amount = ""
    @Published var contact = ""
    @Published var type: BorrowLendType = .lent
    
    private var itemToEdit: BorrowLendModel?
    var isEditing: Bool { itemToEdit != nil }

    func setup(for item: BorrowLendModel?) {
        guard let item = item else { return }
        self.itemToEdit = item
        
        name = item.name
        amount = String(describing: item.amount)
        contact = item.contact ?? ""
        type = item.type
    }

    func save(context: ModelContext) -> Result<Void, ValidationError> {
        guard !name.isEmpty else { return .failure(.missingTitle(field: "Person's Name")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        
        let item = itemToEdit ?? BorrowLendModel(name: "", amount: 0, contact: nil, type: .lent)
        
        item.name = name
        item.amount = amountValue
        item.contact = contact.isEmpty ? nil : contact
        item.type = type
        
        if !isEditing {
            context.insert(item)
        }
        
        return .success(())
    }
}
