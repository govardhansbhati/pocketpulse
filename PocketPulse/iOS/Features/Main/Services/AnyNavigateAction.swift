//
//  AnyNavigateAction.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI

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

struct PresentSheetAction<SheetType: Identifiable> {
    let action: (SheetType) -> Void
    func callAsFunction(_ sheet: SheetType) { action(sheet) }
}

// Environment Keys Home
private struct NavigateHomeKey: EnvironmentKey {
    static let defaultValue: NavigateAction<HomeRoute>? = nil
}
private struct PresentSheetKey: EnvironmentKey {
    static let defaultValue: PresentSheetAction<HomeRoute.Sheet>? = nil
}
 // Wallet
private struct NavigateWalletKey: EnvironmentKey {
    static let defaultValue: NavigateAction<WalletRoute>? = nil
}
private struct PresentWalletSheetKey: EnvironmentKey {
    static let defaultValue: PresentSheetAction<WalletRoute.Sheet>? = nil
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
    
    var navigateBill: NavigateAction<BillRoute>? {
        get { (self[NavigateEnvironmentKey.self] as? AnyNavigateActionBox<BillRoute>)?.action }
        set { self[NavigateEnvironmentKey.self] = newValue.map { AnyNavigateActionBox($0) } }
    }
    
    var presentSheet: PresentSheetAction<HomeRoute.Sheet>? {
        get { self[PresentSheetKey.self] }
        set { self[PresentSheetKey.self] = newValue }
    }
    
    var navigateWallet: NavigateAction<WalletRoute>? {
        get { self[NavigateWalletKey.self] }
        set { self[NavigateWalletKey.self] = newValue }
    }
    var presentWalletSheet: PresentSheetAction<WalletRoute.Sheet>? {
        get { self[PresentWalletSheetKey.self] }
        set { self[PresentWalletSheetKey.self] = newValue }
    }
}
