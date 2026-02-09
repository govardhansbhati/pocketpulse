//
//  SetPasscodeView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/09/25.
//
import SwiftUI

// MARK: - Set Passcode View
/// A simple view for setting and confirming a new passcode.
struct SetPasscodeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var passcode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var error: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(AppStrings.Passcode.createHeader),
                        footer: Text(AppStrings.Passcode.createFooter).foregroundColor(error == nil ? .gray : .red)) {
                    SecureField(AppStrings.Passcode.enterNewPlaceholder, text: $passcode)
                        .keyboardType(.numberPad)
                    SecureField(AppStrings.Passcode.confirmPlaceholder, text: $confirmPasscode)
                        .keyboardType(.numberPad)
                }
                
                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .navigationTitle(AppStrings.Passcode.setTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppStrings.Common.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppStrings.Common.save) { savePasscode() }
                }
            }
        }
    }
    
    private func savePasscode() {
        guard passcode.count == 4 && passcode.allSatisfy({ $0.isNumber }) else {
            error = AppStrings.Passcode.errorLength
            return
        }
        guard passcode == confirmPasscode else {
            error = AppStrings.Passcode.errorMismatch
            return
        }
        
        // If validation passes, save to keychain and dismiss.
        KeychainManager.save(passcode: passcode)
        dismiss()
    }
}
