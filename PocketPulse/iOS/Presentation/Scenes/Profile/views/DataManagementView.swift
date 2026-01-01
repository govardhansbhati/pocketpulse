//
//  DataManagementView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//
import SwiftUI
import SwiftData
// MARK: - Data Management View
/// A view that allows the user to manage their application data, including exporting and resetting.
struct DataManagementView: View {
    // MARK: - Properties
    @StateObject private var viewModel: DataManagementViewModel
    
    init(viewModel: DataManagementViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            // Section for Cloud Sync (Placeholder for a future feature)
            Section(
                header: Text(AppStrings.Profile.DataManagement.cloudSyncHeader),
                footer: Text(AppStrings.Profile.DataManagement.cloudSyncFooter)
            ) {
                Toggle(AppStrings.Profile.DataManagement.enableSync, isOn: .constant(false))
                    .disabled(true)
            }
            
            // Section for data export
            Section(header: Text(AppStrings.Profile.DataManagement.exportHeader)) {
                Button(action: {
                    Task { await viewModel.generateCSV() }
                }) {
                    Label(AppStrings.Profile.DataManagement.exportCSV, systemImage: AppAssets.Icons.squareAndArrowUp)
                }
            }
            
            // A "Danger Zone" for irreversible actions like resetting the app.
            Section(header: Text(AppStrings.Profile.DataManagement.dangerZone)) {
                Button(AppStrings.Profile.DataManagement.resetData, role: .destructive) {
                    viewModel.isShowingResetAlert = true
                }
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
