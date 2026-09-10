//
//  DetectTransactionIntent.swift
//  PocketPulse
//
//  Created by govardhan singh on 08/09/26.
//

import AppIntents

struct DetectTransactionIntent: AppIntent {
    static var title: LocalizedStringResource = "Detect Transaction"
    static var description = IntentDescription("Parses incoming bank SMS or payment alert into PocketPulse.")
    static var openAppWhenRun: Bool = false
    
    @Parameter(title: "Message Text", description: "The SMS or notification text containing transaction details")
    var text: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("Detect transaction from \(\.$text)")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let detected = TransactionSMSParser.parse(text: text, source: .shortcut) else {
            return .result(dialog: "No valid financial transaction was found in the provided text.")
        }
        
        TransactionDetectionManager.shared.addDetectedTransaction(detected)
        
        let typeStr = detected.type == .expense ? "Expense" : "Income"
        let formattedAmount = String(format: "%.2f", detected.amount)
        return .result(dialog: "\(typeStr) of \(formattedAmount) at \(detected.title) detected for PocketPulse.")
    }
}
