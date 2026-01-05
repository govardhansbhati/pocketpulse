//
//  DataManagementView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//
import SwiftUI
import SwiftData
import UIKit
// MARK: - Data Management View
/// A view that allows the user to manage their application data, including exporting and resetting.
struct DataManagementView: View {
    // MARK: - Properties
    @StateObject private var viewModel: DataManagementViewModel
    
    init(viewModel: DataManagementViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: AppConstants.Layout.spacingLarge) {
                // Cloud Sync Section
                VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                    Text(AppStrings.Profile.DataManagement.cloudSyncHeader)
                        .font(.headline)
                        .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.high))
                        .padding(.horizontal)
                    
                    GlassToggle(title: AppStrings.Profile.DataManagement.enableSync, isOn: .constant(false))
                        .disabled(true)
                        .opacity(AppConstants.Opacity.disabled)
                        .padding(.horizontal)
                    
                    Text(AppStrings.Profile.DataManagement.cloudSyncFooter)
                        .font(.caption)
                        .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.medium))
                        .padding(.horizontal)
                }
                .padding(.top, AppConstants.Layout.spacingLarge)
                
                // Export Section
                VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                    Text(AppStrings.Profile.DataManagement.exportHeader)
                        .font(.headline)
                        .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.high))
                        .padding(.horizontal)
                    
                    GlassButton(
                        title: AppStrings.Profile.DataManagement.exportCSV,
                        icon: AppAssets.Icons.squareAndArrowUp,
                        action: { Task { await viewModel.generateCSV() } }
                    )
                    .padding(.horizontal)
                }
                
                // Danger Zone
                VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                    Text(AppStrings.Profile.DataManagement.dangerZone)
                        .font(.headline)
                        .foregroundColor(.red.opacity(AppConstants.Opacity.high))
                        .padding(.horizontal)
                    
                    GlassButton(
                        title: AppStrings.Profile.DataManagement.resetData,
                        icon: AppAssets.Icons.trash,
                        role: .destructive,
                        action: { viewModel.isShowingResetAlert = true }
                    )
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationTitle(AppStrings.Profile.DataManagement.title)
        .navigationBarTitleDisplayMode(.inline)
        // Present the share sheet when `isShowingShareSheet` is true.
        .sheet(isPresented: $viewModel.isShowingShareSheet) {
            if let data = viewModel.csvData {
                ShareSheet(activityItems: [data])
            }
        }
        // Present the confirmation alert before resetting data.
        .alert(AppStrings.Profile.DataManagement.resetAlertTitle, isPresented: $viewModel.isShowingResetAlert) {
            Button(AppStrings.Profile.DataManagement.resetData, role: .destructive) {
                Task { await viewModel.resetAllData() }
            }
            Button(AppStrings.Common.cancel, role: .cancel) {}
        } message: {
            Text(AppStrings.Profile.DataManagement.resetAlertMessage)
        }
    }
}


// MARK: - Share Sheet
/// A helper view that wraps `UIActivityViewController` to make it usable in SwiftUI.
/// This is the standard way to present a share sheet.
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
