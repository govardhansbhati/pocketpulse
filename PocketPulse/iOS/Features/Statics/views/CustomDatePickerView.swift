//
//  CustomDatePickerView.swift
//  PocketPulse
//
//  Created by govardhan singh on 16/07/25.
//


import SwiftUI

struct CustomDatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var startDate: Date
    @Binding var endDate: Date

    var onApply: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            }
            .navigationTitle("Choose Date Range")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
