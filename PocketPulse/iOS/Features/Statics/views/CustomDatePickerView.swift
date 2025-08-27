//
//  CustomDatePickerView.swift
//  PocketPulse
//
//  Created by govardhan singh on 16/07/25.
//


import SwiftUI

// MARK: - Custom Date Picker View
struct CustomDatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    let minDate: Date
    let maxDate: Date
    
    // The action to perform when the user taps "Apply"
    var onApply: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                DatePicker(
                    "Start Date",
                    selection: $startDate,
                    in: minDate...maxDate, // Restrict the range
                    displayedComponents: .date
                )
                
                DatePicker(
                    "End Date",
                    selection: $endDate,
                    in: startDate...maxDate, // The range starts from the selected `startDate`
                    displayedComponents: .date
                )
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
