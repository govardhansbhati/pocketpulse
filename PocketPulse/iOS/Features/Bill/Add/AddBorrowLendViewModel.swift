//
//  AddBorrowLendViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

// MARK: - Add Borrow/Lend Sheet & ViewModel
class AddBorrowLendViewModel: ObservableObject {
    @Published var name = ""
    @Published var amount = ""
    @Published var contact = ""
    @Published var type: BorrowLendType = .lent

    func save(context: ModelContext) -> Result<Void, ValidationError> {
        guard !name.isEmpty else { return .failure(.missingTitle(field: "Person's Name")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        
        let newEntry = BorrowLendModel(name: name, amount: amountValue, contact: contact.isEmpty ? nil : contact, type: type)
        context.insert(newEntry)
        return .success(())
    }
}
