//
//  AddCardSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI

struct AddCardSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var holderName = ""
    @State private var number = ""
    @State private var type = "Credit"
    @State private var issuer = "Visa"
    
    var onSave: (Card) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Holder Name", text: $holderName)
                TextField("Card Number", text: $number)
                    .keyboardType(.numberPad)
                Picker("Type", selection: $type) {
                    Text("Credit").tag("Credit")
                    Text("Debit").tag("Debit")
                }
                Picker("Issuer", selection: $issuer) {
                    Text("Visa").tag("Visa")
                    Text("Mastercard").tag("Mastercard")
                    Text("Rupay").tag("Rupay")
                }
            }
            .navigationTitle("Add Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
//                        let formatted = "**** **** **** \(number.suffix(4))"
//                        let newCard = Card(holderName: holderName, number: formatted, type: type, issuer: issuer)
//                        onSave(newCard)
                        dismiss()
                    }
                }
            }
        }
    }
}
