//
//  DataManagementViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation
import SwiftUI

@MainActor
final class DataManagementViewModel: ObservableObject {
    @Published var csvData: Data?
    @Published var isShowingShareSheet = false
    @Published var isShowingResetAlert = false
    @Published var errorMessage: String?
    
    private let useCase: DataManagementUseCaseProtocol
    
    init(useCase: DataManagementUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func generateCSV() async {
        do {
            self.csvData = try await useCase.generateCSV()
            if self.csvData != nil {
                self.isShowingShareSheet = true
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func resetAllData() async {
        do {
            try await useCase.resetAllData()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
