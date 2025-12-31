//
//  ProfileViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/09/25.
//

import Foundation
import SwiftUI

@Observable
class ProfileViewModel {
    var name: String {
        didSet {
            // Option 1: Save on set (keep similar behavior to UserProfile for now, but via useCase)
            // But useCase calls might be async or sync. ProfileUseCase is sync in my current impl?
            // Let's check ProfileUseCase. It was sync: func updateUserName(_ name: String)
             save()
        }
    }
    
    private let useCase: ProfileUseCaseProtocol
    
    init(useCase: ProfileUseCaseProtocol) {
        self.useCase = useCase
        self.name = useCase.getUserName()
    }
    
    private func save() {
        useCase.updateUserName(name)
    }
}
