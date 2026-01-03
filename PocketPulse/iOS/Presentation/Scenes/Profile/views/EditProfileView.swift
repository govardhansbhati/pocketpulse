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
        ZStack {
            BackgroundView()
            
            VStack(spacing: AppConstants.Layout.spacingLarge) {
                AppText.Subtitle(text: AppStrings.Profile.personalInfoHeader)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, AppConstants.Layout.spacingLarge)
                
                GlassTextField(placeholder: AppStrings.Profile.namePlaceholder, text: $viewModel.name)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle(AppStrings.Profile.editProfileTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
