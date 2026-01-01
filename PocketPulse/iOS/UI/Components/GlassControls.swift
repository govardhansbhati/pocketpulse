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
    
    var body: some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .keyboardType(keyboardType)
        .font(.system(size: AppConstants.Layout.spacingStandard, design: .rounded))
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

// MARK: - Glass Picker
struct GlassPicker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    let title: String
    @Binding var selection: SelectionValue
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
            
            Menu {
                Picker(title, selection: $selection) {
                    content()
                }
            } label: {
                HStack {
                    // We can't easily display the selected text generically without knowing the type's description
                    // So we rely on the caller to provide a label or just use standard Menu style.
                    // A better approach for "Glass" is a custom button that looks like a field.
                    
                    Text("Select...") // Placeholder, caller usually wants to show selected value. 
                    // To improve this, we might ask for a "label" closure or binding string.
                    Spacer()
                    Image(systemName: AppAssets.Icons.chevronLeftSlashChevronRight) // Using a generic icon or arrow
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
                    Text(selectionLabel.isEmpty ? "Select" : selectionLabel)
                        .font(.system(size: AppConstants.Layout.spacingStandard, design: .rounded))
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
    var icon: String? = nil
    var role: ButtonRole? = nil
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
