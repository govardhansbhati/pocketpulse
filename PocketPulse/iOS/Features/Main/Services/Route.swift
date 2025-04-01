//
//  Route.swift
//  PocketPulse
//
//  Created by govardhan singh on 19/03/25.
//


import SwiftUI
import UIKit

enum Route: Hashable {
    case tab
    case sideMenu
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .tab:
            TabV()
        case .sideMenu:
            Text("SideMenu")
        }
    }
}
