//
//  PasscodeLockView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/09/25.
//
import SwiftUI

/// A view that presents a lock screen, requiring the user to enter their passcode to proceed.
struct PasscodeLockView: View {
    // A binding to the state that controls whether the app is locked.
    // When unlocked, this view will be dismissed.
    @Binding var isLocked: Bool
    
    @State private var enteredPasscode = ""
    @State private var hasError = false
    
    var body: some View {
        VStack(spacing: AppConstants.Layout.footerBottomPadding) {
            Spacer()
            
            Text(AppStrings.Passcode.enterTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // The secure field for passcode entry.
            SecureField(AppStrings.Passcode.digitsPlaceholder, text: $enteredPasscode)
                .keyboardType(.numberPad)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(AppConstants.Layout.cornerRadiusMedium)
                .frame(maxWidth: AppConstants.Size.passcodeFieldWidth)
            
            if hasError {
                Text(AppStrings.Passcode.errorIncorrect)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
        // Use .onChange to automatically check the passcode as the user types.
        .onChange(of: enteredPasscode) { _, newValue in
            // When the user has entered 4 digits, verify the passcode.
            if newValue.count == 4 {
                verifyPasscode()
            }
            // Clear any previous error message as soon as the user starts typing again.
            if !newValue.isEmpty {
                hasError = false
            }
        }
    }
    
    /// Verifies the entered passcode against the one stored in the Keychain.
    private func verifyPasscode() {
        if KeychainManager.getPasscode() == enteredPasscode {
            // If correct, unlock the app with a smooth animation.
            withAnimation {
                isLocked = false
            }
        } else {
            // If incorrect, show an error and clear the field.
            hasError = true
            enteredPasscode = ""
        }
    }
}
