//
//  TransactionDetectionManager.swift
//  PocketPulse
//
//  Created by govardhan singh on 08/09/26.
//

import Combine
import Foundation
import UIKit

@MainActor
protocol TransactionDetectionServiceProtocol: AnyObject {
    var activePromptTransaction: DetectedTransaction? { get }
    var pendingTransactions: [DetectedTransaction] { get }
    var isClipboardDetectionEnabled: Bool { get set }
    
    func checkForClipboardTransaction()
    func addDetectedTransaction(_ transaction: DetectedTransaction)
    func dismissTransaction(_ transaction: DetectedTransaction)
}

@MainActor
final class TransactionDetectionManager: ObservableObject, TransactionDetectionServiceProtocol {
    
    // MARK: - Singleton
    
    static let shared = TransactionDetectionManager()
    
    // MARK: - Published State
    
    @Published var activePromptTransaction: DetectedTransaction?
    @Published var pendingTransactions: [DetectedTransaction] = []
    @Published var isClipboardDetectionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isClipboardDetectionEnabled, forKey: clipboardEnabledKey)
        }
    }
    
    // MARK: - Storage Keys
    
    private let clipboardEnabledKey = "pocketpulse.clipboardDetection.enabled"
    private let pendingQueueKey = "pocketpulse.pendingTransactions.queue"
    private let dismissedHashesKey = "pocketpulse.pendingTransactions.dismissed"
    private var lastObservedClipboardString: String = ""
    
    // MARK: - Initialization
    
    init() {
        if UserDefaults.standard.object(forKey: clipboardEnabledKey) == nil {
            UserDefaults.standard.set(true, forKey: clipboardEnabledKey)
            self.isClipboardDetectionEnabled = true
        } else {
            self.isClipboardDetectionEnabled = UserDefaults.standard.bool(forKey: clipboardEnabledKey)
        }
        
        loadPendingQueue()
    }
    
    // MARK: - Clipboard Detection
    
    func checkForClipboardTransaction() {
        guard isClipboardDetectionEnabled else { return }
        guard UIPasteboard.general.hasStrings else { return }
        guard let clipboardText = UIPasteboard.general.string?.trimmingCharacters(in: .whitespacesAndNewlines),
              !clipboardText.isEmpty else { return }
        
        guard clipboardText != lastObservedClipboardString else { return }
        lastObservedClipboardString = clipboardText
        
        guard let detected = TransactionSMSParser.parse(text: clipboardText, source: .clipboard) else {
            return
        }
        
        if isDismissed(contentHash: detected.contentHash) {
            return
        }
        if pendingTransactions.contains(where: { $0.contentHash == detected.contentHash }) {
            return
        }
        
        addDetectedTransaction(detected)
    }
    
    // MARK: - Queue Management
    
    func addDetectedTransaction(_ transaction: DetectedTransaction) {
        if pendingTransactions.contains(where: { $0.contentHash == transaction.contentHash }) {
            return
        }
        
        if isDismissed(contentHash: transaction.contentHash) {
            return
        }
        
        pendingTransactions.insert(transaction, at: 0)
        persistPendingQueue()
        
        if activePromptTransaction == nil {
            activePromptTransaction = transaction
        }
    }
    
    func dismissTransaction(_ transaction: DetectedTransaction) {
        markDismissed(contentHash: transaction.contentHash)
        pendingTransactions.removeAll(where: { $0.id == transaction.id })
        persistPendingQueue()
        
        activePromptTransaction = pendingTransactions.first
    }
    
    // MARK: - Persistence
    
    private func persistPendingQueue() {
        if let encoded = try? JSONEncoder().encode(pendingTransactions) {
            UserDefaults.standard.set(encoded, forKey: pendingQueueKey)
        }
    }
    
    private func loadPendingQueue() {
        if let data = UserDefaults.standard.data(forKey: pendingQueueKey),
           let decoded = try? JSONDecoder().decode([DetectedTransaction].self, from: data) {
            self.pendingTransactions = decoded
            self.activePromptTransaction = decoded.first
        }
    }
    
    private func isDismissed(contentHash: String) -> Bool {
        let dismissed = UserDefaults.standard.stringArray(forKey: dismissedHashesKey) ?? []
        return dismissed.contains(contentHash)
    }
    
    private func markDismissed(contentHash: String) {
        var dismissed = UserDefaults.standard.stringArray(forKey: dismissedHashesKey) ?? []
        if !dismissed.contains(contentHash) {
            dismissed.append(contentHash)
            if dismissed.count > 100 {
                dismissed.removeFirst(dismissed.count - 100)
            }
            UserDefaults.standard.set(dismissed, forKey: dismissedHashesKey)
        }
    }
}
