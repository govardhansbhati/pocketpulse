//
//  UserProfile.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//


import SwiftUI

/// An observable class to manage the user's profile data.
/// It uses UserDefaults for simple, offline persistence of the user's name.
@Observable
class UserProfile {
    var name: String {
        didSet {
            // Automatically save the name to UserDefaults whenever it changes.
            UserDefaults.standard.set(name, forKey: "userName")
        }
    }
    
    init() {
        // Load the saved name on initialization, or use a default value.
        self.name = UserDefaults.standard.string(forKey: "userName") ?? "PocketPulse User"
    }
}
