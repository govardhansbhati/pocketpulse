//
//  StaticsRoute.swift
//  PocketPulse
//
//  Created by ZMO-MAC-GordhanS-01 on 19/03/25.
//


import SwiftUI
import UIKit

enum StaticsRoute {
    case transaction
    case analytics
    // TODO: need to update later
    @ViewBuilder
    var destination: some View {
        switch self {
        case .transaction:
            BalanceView()
        case .analytics:
            ProfileView()
        }
    }
}