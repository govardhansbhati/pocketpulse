//
//  DetectedTransaction.swift
//  PocketPulse
//
//  Created by govardhan singh on 08/09/26.
//

import Foundation

enum DetectionSource: String, Codable, CaseIterable {
    case clipboard = "Clipboard"
    case shortcut = "Shortcut"
    case manualTest = "Test"
}

struct DetectedTransaction: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let rawText: String
    let amount: Double
    let title: String
    let type: TransactionType
    let category: TransactionCategory
    let date: Date
    let accountHint: String?
    let source: DetectionSource
    let detectedAt: Date
    
    init(
        id: UUID = UUID(),
        rawText: String,
        amount: Double,
        title: String,
        type: TransactionType,
        category: TransactionCategory = .other,
        date: Date = Date(),
        accountHint: String? = nil,
        source: DetectionSource = .clipboard,
        detectedAt: Date = Date()
    ) {
        self.id = id
        self.rawText = rawText
        self.amount = amount
        self.title = title
        self.type = type
        self.category = category
        self.date = date
        self.accountHint = accountHint
        self.source = source
        self.detectedAt = detectedAt
    }
    
    /// Unique signature for deduplication based on content
    var contentHash: String {
        let roundedAmount = String(format: "%.2f", amount)
        let cleanTitle = title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(cleanTitle)_\(roundedAmount)_\(type.rawValue)"
    }
}
