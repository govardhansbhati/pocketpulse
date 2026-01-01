//
//  PlaceholderView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//

import SwiftUI

// MARK: - Placeholder View 
/// A reusable view for displaying a placeholder message when a list is empty.
/// It can optionally include a button to prompt the user for an action.
struct PlaceholderView: View {
    let imageName: String
    let title: String
    let subtitle: String
    
    var buttonLabel: String?
    var buttonAction: (() -> Void)?
    
    var body: some View {
        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
            VStack(spacing: AppConstants.Layout.spacingMedium) {
                // Neon Icon Container
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryColor.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(AppTheme.primaryColor.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: AppTheme.primaryColor.opacity(0.2), radius: 10, x: 0, y: 0)
                    
                    Image(systemName: imageName)
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.primaryColor)
                }
                .padding(.top, AppConstants.Layout.spacingSmall)
                
                // Titles
                VStack(spacing: AppConstants.Layout.spacingSmall) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(AppTheme.adaptiveText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Button
                if let label = buttonLabel, let action = buttonAction {
                    Button(action: action) {
                        Text(label)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                LinearGradient(colors: [AppTheme.primaryColor, AppTheme.secondaryColor], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(30)
                            .shadow(color: AppTheme.primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.top, AppConstants.Layout.spacingSmall)
                }
            }
            .padding(AppConstants.Layout.paddingLarge)
            .frame(maxWidth: .infinity)
        }
    }
}
