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
                Section(header: Text("Create Passcode"), footer: Text("Please enter a 4-digit passcode.").foregroundColor(error == nil ? .gray : .red)) {
                    SecureField("Enter 4-digit passcode", text: $passcode)
                        .keyboardType(.numberPad)
                    SecureField("Confirm passcode", text: $confirmPasscode)
                        .keyboardType(.numberPad)
                }
                
                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .navigationTitle("Set Passcode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { savePasscode() }
                }
            }
        }
    }
    
    private func savePasscode() {
        guard passcode.count == 4 && passcode.allSatisfy({ $0.isNumber }) else {
            error = "Passcode must be 4 digits."
            return
        }
        guard passcode == confirmPasscode else {
            error = "Passcodes do not match."
            return
        }
        
        // If validation passes, save to keychain and dismiss.
        KeychainManager.save(passcode: passcode)
        dismiss()
    }
}
