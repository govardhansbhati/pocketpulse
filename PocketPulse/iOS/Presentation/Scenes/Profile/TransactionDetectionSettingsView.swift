//
//  TransactionDetectionSettingsView.swift
//  PocketPulse
//
//  Created by govardhan singh on 08/09/26.
//

import SwiftUI

struct TransactionDetectionSettingsView: View {
    @ObservedObject private var manager = TransactionDetectionManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingTestAlert = false
    @State private var testAlertMessage = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: AppConstants.Layout.paddingLarge) {
                    // MARK: - Clipboard Detection Toggle Card
                    VStack(alignment: .leading, spacing: AppConstants.Layout.paddingMedium) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.primaryColor.opacity(AppConstants.Opacity.light))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "doc.on.clipboard.fill")
                                    .foregroundColor(AppTheme.primaryColor)
                                    .font(.system(size: 18))
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(AppStrings.Detection.clipboardTitle)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(AppTheme.adaptiveText)
                                Text(AppStrings.Detection.clipboardSubtitle)
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $manager.isClipboardDetectionEnabled)
                                .labelsHidden()
                                .tint(AppTheme.primaryColor)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                 style: .continuous)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                    )
                    
                    // MARK: - Shortcuts Automation Guide
                    VStack(alignment: .leading, spacing: AppConstants.Layout.paddingMedium) {
                        HStack(spacing: 8) {
                            Image(systemName: "bolt.badge.automatic.fill")
                                .foregroundColor(AppTheme.secondaryColor)
                                .font(.system(size: 18))
                            Text(AppStrings.Detection.shortcutsTitle)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.adaptiveText)
                        }
                        
                        Text(AppStrings.Detection.shortcutsSubtitle)
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                        
                        VStack(alignment: .leading, spacing: 14) {
                            guideStep(
                                number: "1",
                                title: "Create Automation",
                                detail: "Open Apple Shortcuts app > Tap Automation > Tap New Automation (+)"
                            )
                            guideStep(
                                number: "2",
                                title: "Set Message Trigger",
                                detail: "Select Message > Set 'Message Contains' to: debited, spent, credited, UPI"
                            )
                            guideStep(
                                number: "3",
                                title: "Select PocketPulse",
                                detail: "Add Action > Search PocketPulse > Choose 'Detect Transaction' with Shortcut Input"
                            )
                            guideStep(
                                number: "4",
                                title: "Run Automatically",
                                detail: "Set to 'Run Immediately' and turn off 'Notify When Run' for silent background detection"
                            )
                        }
                        .padding(.vertical, 4)
                        
                        // Open Shortcuts button
                        Button(action: {
                            if let url = URL(string: "shortcuts://"), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.up.forward.app")
                                Text(AppStrings.Detection.openShortcuts)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(AppTheme.primaryGradient)
                            )
                            .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                 style: .continuous)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                    )
                    
                    // MARK: - Test Workbench
                    VStack(alignment: .leading, spacing: AppConstants.Layout.paddingMedium) {
                        HStack(spacing: 8) {
                            Image(systemName: "flask.fill")
                                .foregroundColor(AppTheme.income)
                                .font(.system(size: 18))
                            Text(AppStrings.Detection.testTitle)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.adaptiveText)
                        }
                        
                        Text(AppStrings.Detection.testSubtitle)
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                        
                        VStack(spacing: 10) {
                            testButton(
                                title: "☕️ Starbucks Coffee (₹450.00)",
                                sms: "HDFC Bank Alert: A/c *1234 debited for Rs 450.00 on 08-Sep-26 at STARBUCKS. Avl Bal: INR 12,450.00"
                            )
                            testButton(
                                title: "🛍️ Amazon Shopping (₹1,499.00)",
                                sms: "Dear Customer, INR 1,499.00 spent on your ICICI Card ending with 4321 at AMAZON on 08-Sep-26."
                            )
                            testButton(
                                title: "💰 Monthly Salary (+₹75,000.00)",
                                sms: "A/c *5678 credited with INR 75,000.00 on 01-Sep-26 by Salary. Avl Bal: INR 82,300.00"
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusLarge,
                                                 style: .continuous)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal)
                .padding(.vertical, AppConstants.Layout.paddingMedium)
            }
        }
        .navigationTitle(AppStrings.Detection.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Simulation Queued", isPresented: $showingTestAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(testAlertMessage)
        }
    }
    
    // MARK: - Subviews
    
    private func guideStep(number: String, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppTheme.primaryColor.opacity(AppConstants.Opacity.light))
                    .frame(width: 24, height: 24)
                Text(number)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.primaryColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.adaptiveText)
                Text(detail)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
            }
        }
    }
    
    private func testButton(title: String, sms: String) -> some View {
        Button(action: {
            if let parsed = TransactionSMSParser.parse(text: sms, source: .manualTest) {
                manager.addDetectedTransaction(parsed)
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                testAlertMessage = "Detected \(parsed.title) (\(String(format: "%.2f", parsed.amount))). Go back to Home to see the prompt card!"
                showingTestAlert = true
            }
        }) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(AppTheme.adaptiveText)
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(AppTheme.primaryColor)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.08))
            )
        }
    }
}
