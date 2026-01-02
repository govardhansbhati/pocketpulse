//
//  Notification+Extension.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import Foundation

extension Notification.Name {
    static let walletDataChanged = Notification.Name("walletDataChanged")
    static let billDataChanged = Notification.Name("billDataChanged")
    static let transactionDataChanged = Notification.Name("transactionDataChanged")
}
