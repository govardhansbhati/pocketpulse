//
//  ProfileUseCase.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 02/09/25.
//

import Foundation

protocol ProfileUseCaseProtocol {
    func getUserName() -> String
    func updateUserName(_ name: String)
}

final class ProfileUseCase: ProfileUseCaseProtocol {
    private let service: ProfileServiceProtocol
    
    init(service: ProfileServiceProtocol) {
        self.service = service
    }
    
    func getUserName() -> String {
        service.getUserName()
    }
    
    func updateUserName(_ name: String) {
        service.saveUserName(name)
    }
}
