//
//  AddBillViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

// MARK: - Add Bill Sheet & ViewModel
class AddBillViewModel: ObservableObject {
    @Published var title = ""
    @Published var amount = ""
    @Published var dueDate = Date()

    func save(context: ModelContext) -> Result<Void, ValidationError> {
        guard !title.isEmpty else { return .failure(.missingTitle(field: "Bill Title")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        
        let newBill = BillModel(title: title, amount: amountValue, dueDate: dueDate)
        context.insert(newBill)
        return .success(())
    }
}
