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
                                .fill(AppTheme.primaryGradient.opacity(AppConstants.Opacity.faint))
                                .frame(width: AppConstants.Size.profileImageSize,
                                       height: AppConstants.Size.profileImageSize)
                                .overlay(Circle()
                                    .stroke(AppTheme.primaryColor.opacity(AppConstants.Opacity.low),
                                            lineWidth: AppConstants.Layout.borderWidth))
                            
                            Image(systemName: AppAssets.Icons.personCircleFill)
                                .font(.system(size: AppConstants.Size.iconProfilePlaceholder))
                                .foregroundColor(AppTheme.primaryColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            AppText.Title(text: userProfile.name)
                            AppText.Caption(text: AppStrings.Profile.tapToEdit)
                        }
                        
                        Spacer()
                        
                        Image(systemName: AppAssets.Icons.chevronRight)
                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.dim))
                    }
                    .padding()
                    .background(
                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusExtraLarge) { Color.clear }
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.top, AppConstants.Layout.footerBottomPadding)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // App Settings
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingMedium) {
                            AppText.Subtitle(text: AppStrings.Profile.appSettingsHeader)
                                .padding(.leading)
                            
                            VStack(spacing: AppConstants.Layout.spacingMedium) {
                                menuRow(title: AppStrings.Profile.menuDailyReminder,
                                        icon: AppAssets.Icons.clockArrowCirclepath,
                                        destination: DailyReminderSettingsView())
                                menuRow(title: AppStrings.Profile.menuSecurity,
                                        icon: AppAssets.Icons.lockShieldFill,
                                        destination: SecuritySettingsView())
                                menuRow(title: AppStrings.Profile.menuDataManagement,
                                        icon: AppAssets.Icons.icloudAndArrowDownFill,
                                        destination: ProfileFactory(context: context).makeDataManagementView())
                            }
                        }
                        
                        // Information
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingMedium) {
                            AppText.Subtitle(text: AppStrings.Profile.informationHeader)
                                .padding(.leading)
                            
                            VStack(spacing: AppConstants.Layout.spacingMedium) {
                                menuRow(title: AppStrings.Profile.menuAboutDeveloper,
                                        icon: AppAssets.Icons.personFill,
                                        destination: aboutDeveloperView)
                                
                                // Rate App Button
                                Button(action: {
                                    // Rate action
                                }, label: {
                                    HStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                                                .fill(Color.yellow.opacity(AppConstants.Opacity.faint))
                                                .frame(width: AppConstants.Size.iconHeader,
                                                       height: AppConstants.Size.iconHeader)
                                            Image(systemName: AppAssets.Icons.starFill)
                                                .foregroundColor(.yellow)
                                        }
                                        AppText.Body(text: AppStrings.Profile.menuRateApp)
                                        Spacer()
                                        Image(systemName: AppAssets.Icons.chevronRight)
                                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.low))
                                    }
                                    .padding()
                                    .background(
                                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) { Color.clear }
                                    )
                                })
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, AppConstants.Layout.footerBottomPadding)
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
                        .fill(AppTheme.primaryColor.opacity(AppConstants.Opacity.faint))
                        .frame(width: AppConstants.Size.iconHeader, height: AppConstants.Size.iconHeader)
                    Image(systemName: icon)
                        .foregroundColor(AppTheme.primaryColor)
                }
                AppText.Body(text: title)
                Spacer()
                Image(systemName: AppAssets.Icons.chevronRight)
                    .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.low))
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
                AppText.Body(text: AppStrings.Profile.aboutMeText)
                    .padding()
                    .background(GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) { Color.clear })
                
                HStack(spacing: 20) {
                    if let url = URL(string: AppConstants.Links.github) {
                        Link(destination: url) {
                            Label(AppStrings.Profile.viewGithub, systemImage: "link")
                                .foregroundColor(AppTheme.primaryColor)
                                .padding()
                                .background(GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                                    Color.clear
                                })
                        }
                    }
                    if let url = URL(string: AppConstants.Links.linkedIn) {
                        Link(destination: url) {
                            Label(AppStrings.Profile.connectLinkedIn, systemImage: "link")
                                .foregroundColor(AppTheme.primaryColor)
                                .padding()
                                .background(GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                                    Color.clear
                                })
                        }
                    }
                }
                Spacer()
            }
            .padding(AppConstants.Layout.paddingMedium)
            .navigationTitle(AppStrings.Profile.aboutMeTitle)
        }
    }
}
