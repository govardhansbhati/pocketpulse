//
//  HomeRoute.swift
//  PocketPulse
//
//  Created by govardhan singh on 19/03/25.
//


import SwiftUI
import UIKit

enum HomeRoute: Hashable {
    case balance
    case profile
    case notification
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
        }
    }
}
