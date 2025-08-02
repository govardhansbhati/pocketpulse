//
//  AccountStatus.swift
//  PocketPulse
//
//  Created by govardhan singh on 27/07/25.
//

import SwiftUI

enum AccountStatus: String, Codable, CaseIterable, Identifiable {
    case active = "Active"
    case inactive = "Inactive"
    case closed = "Closed"
    case frozen = "Frozen"

    var id: String { self.rawValue }
}

// This enum focuses only on where money is held.
enum AccountType: String, Codable, CaseIterable, Identifiable {
    case savings
    case current
    case cash // For tracking physical cash in your wallet
    
    var id: String { self.rawValue }
}
