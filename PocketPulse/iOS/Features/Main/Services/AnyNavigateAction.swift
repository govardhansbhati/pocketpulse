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
