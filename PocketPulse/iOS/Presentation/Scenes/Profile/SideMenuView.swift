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
        ZStack {
            BackgroundView()
            
            VStack(spacing: 24) {
                // Header Profile Section
                NavigationLink(destination: EditProfileView(viewModel: userProfile)) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(AppTheme.primaryGradient.opacity(0.1))
                                .frame(width: 80, height: 80) // TODO: Add specific profile constant if needed
                                .overlay(Circle().stroke(AppTheme.primaryColor.opacity(0.3), lineWidth: 1))
                            
                            Image(systemName: AppAssets.Icons.personCircleFill)
                                .font(.system(size: 40))
                                .foregroundColor(AppTheme.primaryColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userProfile.name)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.adaptiveText)
                            Text("Tap to edit profile")
                                .font(.caption)
                                .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        Image(systemName: AppAssets.Icons.chevronRight)
                            .foregroundColor(AppTheme.adaptiveText.opacity(0.5))
                    }
                    .padding()
                    .background(
                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusExtraLarge) { Color.clear }
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // App Settings
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingMedium) {
                            Text(AppStrings.Profile.appSettingsHeader)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading)
                            
                            VStack(spacing: AppConstants.Layout.spacingMedium) {
                                menuRow(title: AppStrings.Profile.menuDailyReminder, icon: AppAssets.Icons.clockArrowCirclepath, destination: DailyReminderSettingsView())
                                menuRow(title: AppStrings.Profile.menuSecurity, icon: AppAssets.Icons.lockShieldFill, destination: SecuritySettingsView())
                                menuRow(title: AppStrings.Profile.menuDataManagement, icon: AppAssets.Icons.icloudAndArrowDownFill, destination: ProfileFactory(context: context).makeDataManagementView())
                            }
                        }
                        
                        // Information
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingMedium) {
                            Text(AppStrings.Profile.informationHeader)
                                .font(.headline)
                                .foregroundColor(AppTheme.adaptiveText)
                                .padding(.leading)
                            
                            VStack(spacing: AppConstants.Layout.spacingMedium) {
                                menuRow(title: AppStrings.Profile.menuAboutDeveloper, icon: AppAssets.Icons.personFill, destination: aboutDeveloperView)
                                
                                // Rate App Button
                                Button(action: {
                                    // Rate action
                                }) {
                                    HStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                                                .fill(Color.yellow.opacity(0.1))
                                                .frame(width: 36, height: 36)
                                            Image(systemName: AppAssets.Icons.starFill)
                                                .foregroundColor(.yellow)
                                        }
                                        Text(AppStrings.Profile.menuRateApp)
                                            .font(.body)
                                            .foregroundColor(AppTheme.adaptiveText)
                                        Spacer()
                                        Image(systemName: AppAssets.Icons.chevronRight)
                                            .foregroundColor(AppTheme.adaptiveText.opacity(0.3))
                                    }
                                    .padding()
                                    .background(
                                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) { Color.clear }
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom) // Allow scroll to bottom
    }
    
    // MARK: - Helper Views
    
    // Generic menu row for navigation
    private func menuRow<Destination: View>(title: String, icon: String, destination: Destination) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                        .fill(AppTheme.primaryColor.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .foregroundColor(AppTheme.primaryColor)
                }
                Text(title)
                    .font(.body)
                    .foregroundColor(AppTheme.adaptiveText)
                Spacer()
                Image(systemName: AppAssets.Icons.chevronRight)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.3))
            }
            .padding()
            .background(
                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) { Color.clear }
            )
        }
        .buttonStyle(.plain)
    }
    
    /// A simple view containing information about the developer.
    private var aboutDeveloperView: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingStandard) {
                Text(AppStrings.Profile.aboutMeText)
                    .font(.body)
                    .foregroundColor(AppTheme.adaptiveText)
                    .padding()
                    .background(GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) { Color.clear })
                
                HStack(spacing: 20) {
                    Link(destination: URL(string: "https://github.com/govardhansbhati")!) {
                        Label(AppStrings.Profile.viewGithub, systemImage: "link")
                            .foregroundColor(AppTheme.primaryColor)
                            .padding()
                            .background(GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) { Color.clear })
                    }
                    Link(destination: URL(string: "https://www.linkedin.com/in/govardhan-singh-bhati--b68650147/")!) {
                        Label(AppStrings.Profile.connectLinkedIn, systemImage: "link")
                            .foregroundColor(AppTheme.primaryColor)
                             .padding()
                             .background(GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) { Color.clear })
                    }
                }
                Spacer()
            }
            .padding(AppConstants.Layout.paddingMedium)
            .navigationTitle(AppStrings.Profile.aboutMeTitle)
        }
    }
}

