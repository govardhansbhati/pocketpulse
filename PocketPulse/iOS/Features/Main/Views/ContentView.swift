//
//  ContentView.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/12/24.
//

import SwiftUI
import UIKit

enum AppScreen: Hashable, Identifiable, CaseIterable {
    var id: AppScreen { self }
    
    case home
    case statics
    case bill
    case wallet
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            Label("Home", systemImage: "house.fill")
        case .statics:
            Label("statics", systemImage: "indianrupeesign.gauge.chart.leftthird.topthird.rightthird")
        case .bill:
            Label("bill", systemImage: "wallet.pass")
        case .wallet:
            Label("wallet", systemImage: "wallet.bifold")
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


protocol AnyNavigateAction {
    func eraseCallAsFunction(_ route: Any)
}

class AnyNavigateActionBox<RouteType>: AnyNavigateAction {
    let action: NavigateAction<RouteType>
    
    init(_ action: NavigateAction<RouteType>) {
        self.action = action
    }
    
    func eraseCallAsFunction(_ route: Any) {
        if let route = route as? RouteType {
            action(route)
        }
    }
}

struct NavigateAction<RouteType> {
    typealias Action = (RouteType) -> ()
    let action: Action
    
    func callAsFunction(_ route: RouteType) {
        action(route)
    }
}

protocol NavigateEnvironmentKeyProtocol {
    associatedtype RouteType
    static var defaultValue: NavigateAction<RouteType> { get }
}

struct NavigateEnvironmentKey: EnvironmentKey {
    static var defaultValue: AnyNavigateAction? = nil
}


extension EnvironmentValues {
    var navigateRoute: NavigateAction<Route>? {
        get { (self[NavigateEnvironmentKey.self] as? AnyNavigateActionBox<Route>)?.action }
        set { self[NavigateEnvironmentKey.self] = newValue.map { AnyNavigateActionBox($0) } }
    }
    
    var navigateHome: NavigateAction<HomeRoute>? {
        get { (self[NavigateEnvironmentKey.self] as? AnyNavigateActionBox<HomeRoute>)?.action }
        set { self[NavigateEnvironmentKey.self] = newValue.map { AnyNavigateActionBox($0) } }
    }
    
    var navigateStatics: NavigateAction<StaticsRoute>? {
        get { (self[NavigateEnvironmentKey.self] as? AnyNavigateActionBox<StaticsRoute>)?.action }
        set { self[NavigateEnvironmentKey.self] = newValue.map { AnyNavigateActionBox($0) } }
    }
}


struct TabbarView: View {
    
    @Binding var selection: AppScreen? 
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem {
                        screen.label
                    }
            }
        }
    }
}

struct TabV: View {
    @State var selection: AppScreen? = .home
    var body: some View {
        TabbarView(selection: $selection)
    }
}



