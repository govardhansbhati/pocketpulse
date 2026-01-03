//
//  DataUpdateService.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import Combine
import Foundation


protocol DataUpdateServiceProtocol {
    var transactionUpdated: PassthroughSubject<Void, Never> { get }
    var walletUpdated: PassthroughSubject<Void, Never> { get }
    var billUpdated: PassthroughSubject<Void, Never> { get }
    
    func notifyTransactionUpdated()
    func notifyWalletUpdated()
    func notifyBillUpdated()
}

final class DataUpdateService: DataUpdateServiceProtocol {
    // Shared instance for container usage, but accessed via protocol injection
    static let shared = DataUpdateService()
    
    // Publishers
    let transactionUpdated = PassthroughSubject<Void, Never>()
    let walletUpdated = PassthroughSubject<Void, Never>()
    let billUpdated = PassthroughSubject<Void, Never>()
    
    private init() {}
    
    func notifyTransactionUpdated() {
        transactionUpdated.send()
    }
    
    func notifyWalletUpdated() {
        walletUpdated.send()
    }
    
    func notifyBillUpdated() {
        billUpdated.send()
    }
}
