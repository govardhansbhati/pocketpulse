//
//  KeychainManager.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 01/09/25.
//

import SwiftUI
import Security

// MARK: - Keychain Manager
/// A utility struct to handle all interactions with the iOS Keychain for securely storing the passcode.
struct KeychainManager {
    private static let service = "com.YourApp.PocketPulse" // A unique identifier for your app's keychain items.
    private static let account = "userPasscode"
    
    /// Saves the user's passcode securely to the Keychain.
    static func save(passcode: String) {
        guard let data = passcode.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        // Delete any existing passcode before saving the new one.
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error saving passcode to Keychain: \(status)")
            return
        }
    }
    
    /// Retrieves the user's passcode from the Keychain.
    static func getPasscode() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    /// Deletes the user's passcode from the Keychain.
    static func deletePasscode() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Error deleting passcode from Keychain: \(status)")
        }
    }
}
