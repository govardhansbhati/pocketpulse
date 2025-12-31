//
//  EditProfileView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//

import SwiftUI

/// A view that allows the user to edit their profile information.
struct EditProfileView: View {
    /// The user profile is passed in from the environment, so this view always
    /// reads and writes to the single source of truth.
    @Bindable var userProfile: UserProfile

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Your Name", text: $userProfile.name)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
