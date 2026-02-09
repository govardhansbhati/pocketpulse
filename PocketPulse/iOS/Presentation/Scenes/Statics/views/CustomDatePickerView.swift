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
    
    init(startDate: Binding<Date>,
         endDate: Binding<Date>,
         minDate: Date,
         maxDate: Date,
         onApply: @escaping () -> Void) {
        self._startDate = startDate
        self._endDate = endDate
        self.minDate = minDate
        self.maxDate = maxDate
        self.onApply = onApply
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: AppConstants.Layout.spacingLarge) {
                // Header
                HStack {
                    Button(action: { dismiss() }, label: {
                        Text(AppStrings.Common.cancel)
                            .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                    })
                    Spacer()
                    Text(AppStrings.Statics.customTitle)
                        .font(.headline)
                        .foregroundColor(AppTheme.adaptiveText)
                    Spacer()
                    Button(action: {
                        onApply()
                        dismiss()
                    }, label: {
                        Text(AppStrings.Statics.apply)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.primaryColor)
                    })
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: AppConstants.Layout.spacingLarge) {
                        
                        // Start Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text(AppStrings.Statics.startDate)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, 4)
                            
                            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                                DatePicker(
                                    "",
                                    selection: $startDate,
                                    in: minDate...maxDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.graphical)
                                .padding()
                            }
                        }
                        
                        // End Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text(AppStrings.Statics.endDate)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading, 4)
                            
                            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                                DatePicker(
                                    "",
                                    selection: $endDate,
                                    in: startDate...maxDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.graphical)
                                .padding()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .textInputAutocapitalization(.never) // Modifier not strictly needed but good practice for form-like views
        .onChange(of: startDate) {
            if startDate > endDate {
                endDate = startDate
            }
        }
    }
}
