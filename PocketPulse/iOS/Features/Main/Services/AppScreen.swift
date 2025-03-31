//
//  AppScreen.swift
//  PocketPulse
//
//  Created by ZMO-MAC-GordhanS-01 on 26/03/25.
//

import SwiftUI

enum AppScreen: Hashable, Identifiable, CaseIterable {
    var id: AppScreen { self }
    
    case home
    case statics
    case bill
    case wallet
}

extension AppScreen {
    
    var title: String {
            switch self {
            case .home: return "Home"
            case .statics: return "Statics"
            case .bill: return "Bill"
            case .wallet: return "Wallet"
            }
        }
    
    @ViewBuilder
    var icon: some View {
        switch self {
        case .home:
            Image(systemName: "house.fill")
        case .statics:
            Image(systemName: "indianrupeesign.gauge.chart.leftthird.topthird.rightthird")
        case .bill:
            Image(systemName: "wallet.pass")
        case .wallet:
            Image(systemName: "wallet.bifold")
        }
        
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeNavigationStack()
        case .statics:
            StaticsView()
        case .bill:
            BillView()
        case .wallet:
            WalletView()
        }
    }
}
