//
//  AddBillSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//
import SwiftUI

struct AddBillSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var amount = ""
    @State private var dueDate = Date()
    
    var onSave: (Bill) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bill Details")) {
                    TextField("Title", text: $title)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Bill")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amt = Double(amount) {
                            let newBill = Bill(title: title, amount: amt, dueDate: dueDate)
                            onSave(newBill)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
