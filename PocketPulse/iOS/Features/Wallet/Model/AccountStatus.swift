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
