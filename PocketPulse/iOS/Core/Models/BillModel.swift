//
//  Bill.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import SwiftUI
import SwiftData

// MARK: - Bill Model (SwiftData)
@Model
class BillModel {
    var id: UUID
    var title: String
    var amount: Double
    var dueDate: Date
    var isPaid: Bool // To track if the bill has been paid

    init(title: String, amount: Double, dueDate: Date, isPaid: Bool = false) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.dueDate = dueDate
        self.isPaid = isPaid
    }
}
