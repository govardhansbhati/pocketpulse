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
    
    init(startDate: Binding<Date>, endDate: Binding<Date>, minDate: Date, maxDate: Date, onApply: @escaping () -> Void) {
        self._startDate = startDate
        self._endDate = endDate
        self.minDate = minDate
        self.maxDate = maxDate
        self.onApply = onApply
    }
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker(
                    AppStrings.Statics.startDate,
                    selection: $startDate,
                    in: minDate...maxDate, // Restrict the range
                    displayedComponents: .date
                )
                
                DatePicker(
                    AppStrings.Statics.endDate,
                    selection: $endDate,
                    in: startDate...maxDate, // The range starts from the selected `startDate`
                    displayedComponents: .date
                )
            }
            .navigationTitle(AppStrings.Statics.customTitle)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppStrings.Statics.apply) {
                        onApply()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppStrings.Common.cancel) {
                        dismiss()
                    }
                }
            }
            .onChange(of: startDate) {
                if startDate > endDate {
                    endDate = startDate
                }
            }
        }
    }
}
