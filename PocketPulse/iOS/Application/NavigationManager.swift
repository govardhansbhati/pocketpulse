//
//  AnyNavigateAction.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI

// MARK: - Type-Erased Navigation
/// A protocol used for type erasure. This allows different `NavigateAction` types
/// (like `NavigateAction<HomeRoute>` and `NavigateAction<WalletRoute>`) to be stored
/// in a single environment key, which is not possible with strongly typed generics.
protocol AnyNavigateAction {
    func eraseCallAsFunction(_ route: Any)
}

/// A concrete box that holds a specific `NavigateAction`. It conforms to `AnyNavigateAction`
/// and safely attempts to cast the `Any` route back to its original `RouteType` before
/// executing the action. This is the core of the type erasure pattern.
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

// MARK: - Reusable Navigation Actions
/// A generic struct that encapsulates a navigation action.
/// This allows views to trigger navigation without needing a direct reference
/// to a `NavigationPath` or `NavigationStack`.
struct NavigateAction<RouteType> {
    typealias Action = (RouteType) -> Void
    let action: Action
    
    // The `callAsFunction` allows you to use an instance of this struct like a function,
    // for example: `navigate(HomeRoute.details)`.
    func callAsFunction(_ route: RouteType) {
        action(route)
    }
}

/// A generic struct similar to `NavigateAction`, but specifically for presenting sheets.
/// It requires the `SheetType` to be `Identifiable` to work with the `.sheet(item:)` modifier.
struct PresentSheetAction<SheetType: Identifiable> {
    let action: (SheetType) -> Void
    func callAsFunction(_ sheet: SheetType) { action(sheet) }
}

struct PresentSideMenuAction {
    let action: () -> Void
    func callAsFunction() { action() }
}

// MARK: - Custom Environment Keys
/// Each feature's navigation and sheet actions get their own `EnvironmentKey`.
/// This is a standard SwiftUI pattern for creating custom environment values.
// Home
private struct NavigateHomeKey: EnvironmentKey {
    static let defaultValue: NavigateAction<HomeRoute>? = nil
}
private struct PresentSheetKey: EnvironmentKey {
    static let defaultValue: PresentSheetAction<HomeRoute.Sheet>? = nil
}

private struct PresentSideMenuKey: EnvironmentKey {
    static let defaultValue: PresentSideMenuAction? = nil
}

// Bill
private struct NavigateBillKey: EnvironmentKey {
    static let defaultValue: NavigateAction<BillRoute>? = nil
}
private struct PresentBillSheetKey: EnvironmentKey {
    static let defaultValue: PresentSheetAction<BillRoute.Sheet>? = nil
}

// Wallet
private struct NavigateWalletKey: EnvironmentKey {
    static let defaultValue: NavigateAction<WalletRoute>? = nil
}
private struct PresentWalletSheetKey: EnvironmentKey {
    static let defaultValue: PresentSheetAction<WalletRoute.Sheet>? = nil
}

// A generic key used for the type-erased navigation actions.
struct NavigateEnvironmentKey: EnvironmentKey {
    static var defaultValue: AnyNavigateAction?
}

// MARK: - EnvironmentValues Extension
/// This extension makes the navigation actions easily accessible from any view
/// using the `@Environment` property wrapper (e.g., `@Environment(\.navigateHome)`).
extension EnvironmentValues {
    // This is a generic property that uses the type erasure box. It's a bit more complex.
    var navigateRoute: NavigateAction<Route>? {
        get { (self[NavigateEnvironmentKey.self] as? AnyNavigateActionBox<Route>)?.action }
        set { self[NavigateEnvironmentKey.self] = newValue.map { AnyNavigateActionBox($0) } }
    }
    
    // These are the specific, strongly-typed properties you'll use in your views.
    var navigateHome: NavigateAction<HomeRoute>? {
        get { (self[NavigateEnvironmentKey.self] as? AnyNavigateActionBox<HomeRoute>)?.action }
        set { self[NavigateEnvironmentKey.self] = newValue.map { AnyNavigateActionBox($0) } }
    }
    
    var presentSideMenu: PresentSideMenuAction? {
        get { self[PresentSideMenuKey.self] }
        set { self[PresentSideMenuKey.self] = newValue }
    }
    
    var navigateStatics: NavigateAction<StaticsRoute>? {
        get { (self[NavigateEnvironmentKey.self] as? AnyNavigateActionBox<StaticsRoute>)?.action }
        set { self[NavigateEnvironmentKey.self] = newValue.map { AnyNavigateActionBox($0) } }
    }
    
    var navigateBill: NavigateAction<BillRoute>? {
        get { self[NavigateBillKey.self] }
        set { self[NavigateBillKey.self] = newValue }
    }
    var presentBillSheet: PresentSheetAction<BillRoute.Sheet>? {
        get { self[PresentBillSheetKey.self] }
        set { self[PresentBillSheetKey.self] = newValue }
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

// MARK: - Global App Routes
/// Defines the top-level navigation routes for the entire application.
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
