//
//  Bill.swift
//  PocketPulse
//
//  Created by ZMO-MAC-GordhanS-01 on 13/07/25.
//

import SwiftUI

// MARK: - Models
struct Bill: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let dueDate: Date
}

enum BillSection: String, CaseIterable, Identifiable {
    case bills = "Bills"
    case borrowLend = "Borrowed/Lent"
    
    var id: String { self.rawValue }
}

struct BorrowLend: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let contact: String
}
