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
    @Environment(\.modelContext) private var context
    
    // State to control the presentation of the CSV share sheet and the reset confirmation alert.
    @State private var isShowingShareSheet = false
    @State private var isShowingResetAlert = false
    
    // State to hold the generated CSV data that will be shared.
    @State private var csvData: Data?

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
                Button(action: exportTransactions) {
                    Label("Export Transactions as CSV", systemImage: "square.and.arrow.up")
                }
            }
            
            // A "Danger Zone" for irreversible actions like resetting the app.
            Section(header: Text("Danger Zone")) {
                Button("Reset All Data", role: .destructive) {
                    isShowingResetAlert = true
                }
            }
        }
        .navigationTitle("Data Management")
        .navigationBarTitleDisplayMode(.inline)
        // Present the share sheet when `isShowingShareSheet` is true.
        .sheet(isPresented: $isShowingShareSheet) {
            if let data = csvData {
                ShareSheet(activityItems: [data])
            }
        }
        // Present the confirmation alert before resetting data.
        .alert("Are you sure?", isPresented: $isShowingResetAlert) {
            Button("Reset All Data", role: .destructive, action: resetAllData)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all accounts, cards, transactions, and bills. This action cannot be undone.")
        }
    }
    
    // MARK: - Private Methods
    
    /// Gathers all transactions, generates a CSV file, and prepares it for sharing.
    private func exportTransactions() {
        let allTransactions = (try? context.fetch(FetchDescriptor<TransactionModel>())) ?? []
        self.csvData = DataManager.generateCSV(from: allTransactions)
        isShowingShareSheet = true
    }
    
    /// Calls the DataManager to delete all user data from the app.
    private func resetAllData() {
        DataManager.resetAllData(in: context)
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
