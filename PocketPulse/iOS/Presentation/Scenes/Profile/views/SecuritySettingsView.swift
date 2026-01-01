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
        Form {
            Section(
                header: Text(AppStrings.Profile.Security.appLockHeader),
                footer: Text(AppStrings.Profile.Security.appLockFooter)
            ) {
                // This toggle controls whether the passcode is enabled.
                Toggle(AppStrings.Profile.Security.enablePasscode, isOn: $isPasscodeEnabled)
            }
            
            // This section only appears if the passcode is enabled.
            if isPasscodeEnabled {
                Section(header: Text(AppStrings.Profile.Security.biometricsHeader)) {
                    // This is a placeholder for future implementation.
                    // The logic to check for Face ID/Touch ID and enable this would go here.
                    Toggle(AppStrings.Profile.Security.useBiometrics, isOn: .constant(false))
                        .disabled(true)
                }
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
