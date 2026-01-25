//
//  GlassControls.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftUI
import UIKit

// MARK: - Glass Text Field
struct GlassTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Animated Floating Label
            AppText.Body(text: placeholder,
                         color: AppTheme.adaptiveText.opacity((text.isEmpty && !isFocused) ? 0.6 : 1.0))
                .scaleEffect((text.isEmpty && !isFocused) ? 1.0 : 0.75, anchor: .leading)
                .offset(y: (text.isEmpty && !isFocused) ? 0 : -28)
                .scaleEffect((text.isEmpty && !isFocused) ? 1.0 : 0.9, anchor: .leading)
                .animation(.easeInOut(duration: 0.2), value: text.isEmpty || isFocused)

            // Input Field
            if isSecure {
                SecureField("", text: $text)
                    .focused($isFocused)
            } else {
                TextField("", text: $text)
                    .focused($isFocused)
            }
        }
        .padding(.top, (text.isEmpty && !isFocused) ? 0 : 12)
        .keyboardType(keyboardType)
        .font(.system(size: AppConstants.Layout.spacingStandard, design: .rounded))
        .foregroundColor(AppTheme.adaptiveText)
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                        .stroke(Color.white.opacity(isFocused ? 0.5 : 0.2), lineWidth: 1)
                )
        )
        .animation(.default, value: isFocused)
    }
}

// MARK: - Glass Picker
struct GlassPicker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    let title: String
    @Binding var selection: SelectionValue
    var selectionLabel: String // Display value representing the selection
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                .padding(.leading, 4)
            
            Menu {
                Picker(title, selection: $selection) {
                    content()
                }
            } label: {
                HStack {
                    AppText.Body(text: selectionLabel.isEmpty ? AppStrings.Common.selectPlaceholder : selectionLabel)
                    Spacer()
                    Image(systemName: AppAssets.Icons.chevronLeftSlashChevronRight)
                        .font(.caption)
                }
                .foregroundColor(AppTheme.adaptiveText)
                .padding(AppConstants.Layout.paddingMedium)
                .background(
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
    }
}

// Improved Glass Picker that takes a label String
struct LabeledGlassPicker<Content: View>: View {
    let title: String
    let selectionLabel: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                .padding(.leading, AppConstants.Layout.spacingTiny)
            
            Menu {
                content()
            } label: {
                HStack {
                    AppText.Body(text: selectionLabel.isEmpty ? AppStrings.Common.select : selectionLabel)
                        .foregroundColor(AppTheme.adaptiveText)
                    Spacer()
                    Image(systemName: AppAssets.Icons.arrowDown)
                        .font(.caption)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                }
                .padding(AppConstants.Layout.paddingMedium)
                .background(
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
    }
}
// MARK: - Glass Toggle
struct GlassToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(AppTheme.adaptiveText)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppTheme.primaryColor)
        }
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) { Color.clear }
        )
    }
}

// MARK: - Glass Button
struct GlassButton: View {
    let title: String
    var icon: String?
    var role: ButtonRole?
    let action: () -> Void
    
    var body: some View {
        Button(role: role, action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.headline)
            .foregroundColor(role == .destructive ? .red : AppTheme.adaptiveText)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                    if role != .destructive {
                        AppTheme.primaryColor.opacity(0.1)
                    } else {
                        Color.red.opacity(0.1)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}
