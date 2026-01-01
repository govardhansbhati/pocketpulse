//
//  SecuritySettingsView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/09/25.
//
import SwiftUI

// MARK: - Security Settings View
/// A view that allows the user to configure security settings, such as enabling a passcode.
struct SecuritySettingsView: View {
    // @AppStorage provides a reactive link to UserDefaults for non-sensitive settings.
    @AppStorage("isPasscodeEnabled") private var isPasscodeEnabled: Bool = false
    
    // State to control the presentation of the "Set Passcode" sheet.
    @State private var showSetPasscodeSheet = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: AppConstants.Layout.spacingLarge) {
                // Header
                Text(AppStrings.Profile.Security.appLockHeader)
                    .font(.headline)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, AppConstants.Layout.spacingLarge)
                
                // Passcode Toggle
                GlassToggle(title: AppStrings.Profile.Security.enablePasscode, isOn: $isPasscodeEnabled)
                    .padding(.horizontal)
                
                // Footer
                Text(AppStrings.Profile.Security.appLockFooter)
                    .font(.caption)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Biometrics Section (only if enabled)
                if isPasscodeEnabled {
                    VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                        Text(AppStrings.Profile.Security.biometricsHeader)
                            .font(.headline)
                            .foregroundColor(AppTheme.adaptiveText.opacity(0.8))
                            .padding(.horizontal)
                            .padding(.top)
                        
                        GlassToggle(title: AppStrings.Profile.Security.useBiometrics, isOn: .constant(false))
                            .disabled(true)
                            .opacity(0.6) // Show it's disabled
                            .padding(.horizontal)
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .navigationTitle(AppStrings.Profile.Security.title)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: isPasscodeEnabled) { _, isEnabled in
            if isEnabled {
                // If the user is enabling the passcode and one isn't already set,
                // present the sheet for them to create one.
                if KeychainManager.getPasscode() == nil {
                    showSetPasscodeSheet = true
                }
            } else {
                // If the user disables the passcode, delete it from the Keychain.
                KeychainManager.deletePasscode()
            }
        }
        .sheet(isPresented: $showSetPasscodeSheet) {
            // When the sheet is dismissed, check if a passcode was actually saved.
            // If not (e.g., the user cancelled), turn the toggle back off.
            if KeychainManager.getPasscode() == nil {
                isPasscodeEnabled = false
            }
        } content: {
            SetPasscodeView()
        }
    }
}
