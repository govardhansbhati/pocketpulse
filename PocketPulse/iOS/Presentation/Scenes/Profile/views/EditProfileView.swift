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
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        Form {
            Section(header: Text(AppStrings.Profile.personalInfoHeader)) {
                TextField(AppStrings.Profile.namePlaceholder, text: $viewModel.name)
            }
        }
        .navigationTitle(AppStrings.Profile.editProfileTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
