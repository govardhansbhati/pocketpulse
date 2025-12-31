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
                header: Text("Cloud Sync"),
                footer: Text("iCloud Sync is planned for a future update.")
            ) {
                Toggle("Enable iCloud Sync", isOn: .constant(false))
                    .disabled(true)
            }
            
            // Section for data export
            Section(header: Text("Export Data")) {
                Button(action: {
                    Task { await viewModel.generateCSV() }
                }) {
                    Label("Export Transactions as CSV", systemImage: "square.and.arrow.up")
                }
            }
            
            // A "Danger Zone" for irreversible actions like resetting the app.
            Section(header: Text("Danger Zone")) {
                Button("Reset All Data", role: .destructive) {
                    viewModel.isShowingResetAlert = true
                }
            }
        }
        .navigationTitle("Data Management")
        .navigationBarTitleDisplayMode(.inline)
        // Present the share sheet when `isShowingShareSheet` is true.
        .sheet(isPresented: $viewModel.isShowingShareSheet) {
            if let data = viewModel.csvData {
                ShareSheet(activityItems: [data])
            }
        }
        // Present the confirmation alert before resetting data.
        .alert("Are you sure?", isPresented: $viewModel.isShowingResetAlert) {
            Button("Reset All Data", role: .destructive) {
                Task { await viewModel.resetAllData() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all accounts, cards, transactions, and bills. This action cannot be undone.")
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
