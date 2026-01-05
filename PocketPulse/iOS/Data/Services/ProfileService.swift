//
//  ProfileService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 02/09/25.
//

import Foundation

protocol ProfileServiceProtocol {
    func getUserName() -> String
    func saveUserName(_ name: String)
}

final class ProfileService: ProfileServiceProtocol {
    private let kUserName = "userName"
    
    func getUserName() -> String {
        UserDefaults.standard.string(forKey: kUserName) ?? "PocketPulse User"
    }
    
    func saveUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: kUserName)
    }
}
