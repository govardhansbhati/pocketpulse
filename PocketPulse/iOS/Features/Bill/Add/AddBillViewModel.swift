//
//  AddBillViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 10/08/25.
//
import SwiftUI
import SwiftData

/// Manages the state and logic for the `AddBillSheet`.
class AddBillViewModel: ObservableObject {
    @Published var title = ""
    @Published var amount = ""
    @Published var dueDate = Date()
    
    private var billToEdit: BillModel?
    var isEditing: Bool { billToEdit != nil }

    func setup(for bill: BillModel?) {
        guard let bill = bill else { return }
        self.billToEdit = bill
        
        title = bill.title
        amount = String(describing: bill.amount)
        dueDate = bill.dueDate
    }

    func save(context: ModelContext) -> Result<Void, ValidationError> {
        guard !title.isEmpty else { return .failure(.missingTitle(field: "Bill Title")) }
        guard let amountValue = Double(amount), amountValue > 0 else { return .failure(.invalidAmount) }
        
        let bill = billToEdit ?? BillModel(title: "", amount: 0, dueDate: Date())
        
        bill.title = title
        bill.amount = amountValue
        bill.dueDate = dueDate
        
        if !isEditing {
            context.insert(bill)
        }
        
        return .success(())
    }
}
