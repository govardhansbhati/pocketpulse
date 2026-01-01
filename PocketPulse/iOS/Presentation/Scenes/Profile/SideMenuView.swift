//
//  SideMenuView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//


import SwiftUI

/// A view that presents a side menu with user profile and app settings.
struct SideMenuView: View {
    /// A binding to control the visibility of the menu, passed from the parent view.
    @Binding var isShowing: Bool
    
    @Environment(ProfileViewModel.self) private var userProfile
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(destination: EditProfileView(viewModel: userProfile)) {
                profileHeader
            }
            
            List {
                appSettingsSection
                informationSection
            }
            .listStyle(.insetGrouped)
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Subviews
    
    /// The header view displaying the user's profile information.
    private var profileHeader: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: AppConstants.Size.iconExtraLarge))
                .foregroundColor(.blue)
            
            Text(userProfile.name)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
    }
    
    /// The section for app-specific settings.
    @ViewBuilder
    private var appSettingsSection: some View {
        Section(header: Text(AppStrings.Profile.appSettingsHeader)) {
            NavigationLink(destination: DailyReminderSettingsView()) {
                Label(AppStrings.Profile.menuDailyReminder, systemImage: "clock.arrow.circlepath")
            }
            NavigationLink(destination: SecuritySettingsView()) {
                Label(AppStrings.Profile.menuSecurity, systemImage: "lock.shield.fill")
            }
            NavigationLink(destination: ProfileFactory(context: context).makeDataManagementView()) {
                Label(AppStrings.Profile.menuDataManagement, systemImage: "icloud.and.arrow.down.fill")
            }
        }
    }
    
    /// The section for information about the app and the developer.
    @ViewBuilder
    private var informationSection: some View {
        Section(header: Text(AppStrings.Profile.informationHeader)) {
            NavigationLink(destination: aboutDeveloperView) {
                Label(AppStrings.Profile.menuAboutDeveloper, systemImage: "person.fill")
            }
            // This button will open the App Store review page.
            Button(action: {
                // Future: Add URL to your app on the App Store.
            }) {
                Label(AppStrings.Profile.menuRateApp, systemImage: "star.fill")
            }
        }
    }
    
    /// A simple view containing information about the developer.
    private var aboutDeveloperView: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingStandard) {
            
            Text(AppStrings.Profile.aboutMeText)
                .font(.body)
            
            Divider()
            Link(destination: URL(string: "https://github.com/govardhansbhati")!) {
                Label(AppStrings.Profile.viewGithub, systemImage: "chevron.left.slash.chevron.right")
            }
            Link(destination: URL(string: "https://www.linkedin.com/in/govardhan-singh-bhati--b68650147/")!) {
                Label(AppStrings.Profile.connectLinkedIn, systemImage: "person.crop.circle")
            }
            Spacer()
        }
        .padding()
        .navigationTitle(AppStrings.Profile.aboutMeTitle)
    }
}

