//
//  AddBorrowLendSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI

struct AddBorrowLendSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount = ""
    @State private var contact = ""
    
    var onSave: (BorrowLend) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Borrow/Lent Details")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Contact Number", text: $contact)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amt = Double(amount) {
                            let entry = BorrowLend(name: name, amount: amt, contact: contact)
                            onSave(entry)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
