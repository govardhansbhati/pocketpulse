//
//  AppScreen.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI

// MARK: - App Screen
/// Represents the main tabs in the application's tab bar.
///
/// This enum is `CaseIterable` to allow easy iteration over all tabs,
/// and `Identifiable` to be used in SwiftUI lists and `ForEach` loops.
enum AppScreen: Hashable, Identifiable, CaseIterable {
    var id: AppScreen { self }
    
    // The main tabs of the application.
    case home
    case statics
    case bill
    case wallet
}

extension AppScreen {
    
    /// The user-facing title for each tab.
    var title: String {
        switch self {
        case .home: return "Home"
        case .statics: return "Statistics"
        case .bill: return "Bills"
        case .wallet: return "Wallet"
        }
    }
    
    /// The SF Symbol icon for each tab.
    @ViewBuilder
    var icon: some View {
        switch self {
        case .home:
            Image(systemName: AppAssets.Icons.houseFill)
        case .statics:
            Image(systemName: AppAssets.Icons.chartPieFill)
        case .bill:
            Image(systemName: AppAssets.Icons.listBulletRectanglePortraitFill)
        case .wallet:
            Image(systemName: AppAssets.Icons.walletPassFill) 
        }
    }
    
    /// The root view (including its NavigationStack) for each tab.
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeNavigationStack()
        case .statics:
            StaticNavigationStack()
        case .bill:
            BillNavigationStack()
        case .wallet:
            WalletNavigationStack()
        }
    }
}
