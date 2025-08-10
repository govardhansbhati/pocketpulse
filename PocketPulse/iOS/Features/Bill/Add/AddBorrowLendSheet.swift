//
//  AddBorrowLendSheet.swift
//  PocketPulse
//
//  Created by govardhan singh on 06/07/25.
//

import SwiftUI
import SwiftData

struct AddBorrowLendSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = AddBorrowLendViewModel()
    @State private var validationError: ValidationError?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Entry Details")) {
                    Picker("Type", selection: $viewModel.type) {
                        ForEach(BorrowLendType.allCases) { type in Text(type.rawValue).tag(type) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Person's Name", text: $viewModel.name)
                    TextField("Amount", text: $viewModel.amount).keyboardType(.decimalPad)
                    TextField("Contact Info (Optional)", text: $viewModel.contact)
                }
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { saveEntry() } }
            }
            .alert(item: $validationError) { error in
                Alert(
                    title: Text(error.alert.title),
                    message: Text(error.alert.message),
                    dismissButton: error.alert.primaryButton
                )
            }
        }
    }
    
    private func saveEntry() {
        let result = viewModel.save(context: context)
        if case .failure(let error) = result {
            self.validationError = error
        } else {
            dismiss()
        }
    }
}
