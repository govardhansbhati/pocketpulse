//
//  HomeRoute.swift
//  PocketPulse
//
//  Created by ZMO-MAC-GordhanS-01 on 19/03/25.
//


import SwiftUI
import UIKit

enum HomeRoute: Hashable {
    case balance
    case profile
    case notification
    case transactionList
    // TODO: need to update later
    @ViewBuilder
    var destination: some View {
        switch self {
        case .balance:
            BalanceView()
        case .profile:
            ProfileView()
        case .notification:
            NotificationView()
        case .transactionList:
            TransactionView()
        }
    }
}