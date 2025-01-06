//
//  ContentView.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/12/24.
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

enum Route: Hashable {
    case home(HomeRoute)
    case statics(StaticsRoute)
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home(let  homeRoute):
            homeRoute.destination
        case .statics(let staticsRoute):
            staticsRoute.destination
        }
    }
}

struct NavigateAction {
    typealias Action = (Route) -> ()
    let action: Action
    func callAsFunction(_ route: Route) {
        action(route)
    }
}

struct NavigateEnvironmentKey: EnvironmentKey {
    static var defaultValue: NavigateAction = NavigateAction { _ in }
}

extension EnvironmentValues {
    var navigate: (NavigateAction) {
        get { self[NavigateEnvironmentKey.self] }
        set { self[NavigateEnvironmentKey.self] = newValue }
    }
}

struct ContentView: View {
    
    @State private var routes: [Route] = []
    
    var body: some View {
        NavigationStack(path: $routes) {
        // Wallet view with Animation
        SplashView()
                .navigationDestination(for: Route.self) { route in
                    route.destination
                }
        }.environment(\.navigate, NavigateAction(action: { route in
            routes.append(route)
        }))
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
    @State var selection: AppScreen?
    var body: some View {
        TabbarView(selection: $selection)
    }
}

#Preview {
    TabV()
}


// Define a custom animation for the wallet
struct SplashView: View {
    
    @Environment(\.navigate) private var navigate
    
    @State private var isAnimating = false
    @State private var moveCoinUp = false
    @State private var moveCoinDown = false
    @State private var animationProgress: CGFloat = 0
        @State private var graphPath: [CGFloat] = [0, 10, -5, 15, -10, 5, 8, 12, -6, 10, -5, 15, 12, -6, 3]
        
    let imageCount = 6
    let animationDuration: Double = 2
    let delayBetwnCoins: Double = 0.1
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let imageSize = screenWidth / 4
            let size = min(geometry.size.width, geometry.size.height) / 2
            ZStack {
                // Background Color
                            Color(UIColor.systemGray6)
                                .edgesIgnoringSafeArea(.all)
                
                
                ForEach(0..<imageCount, id: \.self) {index in
                    // Rotating image
                    Image(systemName: "indianrupeesign.circle.fill")
                        .resizable()
                        .frame(width: imageSize / 2, height: imageSize / 2)
                        .foregroundStyle(Color.gray.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                        .offset(y: moveCoinUp ? -size / 2 : 0)
                        .offset(y: moveCoinDown ? size / 2 : 0)
                        .animation(.easeInOut(duration: 1).delay(Double(index) * delayBetwnCoins), value: moveCoinUp)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0), anchor: .center)
                        .animation(Animation.easeInOut(duration: animationDuration)
                            .delay(Double(index) * delayBetwnCoins), value: isAnimating)
                        .animation(.easeInOut(duration: 1).delay(Double(index) * delayBetwnCoins), value: moveCoinDown)
                }
                
                // Centered Wallet image
                Image(systemName: "wallet.bifold.fill")
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .symbolEffect(.pulse.wholeSymbol, options: .nonRepeating, value: moveCoinUp)
                    .symbolEffect(.pulse.wholeSymbol, options: .nonRepeating, value: moveCoinDown)
                    .foregroundStyle(.brown)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 4, y: 4)
                
                
                ZStack {
                    Text("PocketPulse")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Color.black) // Font color
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5) // Shadow for depth
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1) // Border for subtle depth
                                )
                        )
//                        .overlay(
//                            Text("PocketPulse")
//                                .font(.system(size: 36, weight: .bold, design: .rounded))
//                                .foregroundColor(Color.white.opacity(0.6)) // Highlight for 3D effect
//                                .offset(x: -2, y: -2) // Offset for the highlight
//                        )
                    
                    // Graph Line Divider
                    GraphLineDivider(graphPath: graphPath)
                        .trim(from: 0, to: animationProgress)
                        .stroke(
                            Color(UIColor.systemGray6), // Subtle color for the graph line
                            lineWidth: 3
                        )
                        .frame(height: 2)
                        .padding(.horizontal, 16)
                        .offset(y: 0)
                }
                .offset(y: moveCoinUp ? size : 0)
                .onTapGesture {
                    
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                moveCoinUp = true
                let upTime = (Double(imageCount) * delayBetwnCoins) + 1
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime) {
                    isAnimating = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime * 2 + 0.5) {
                    moveCoinDown = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime * 2 + 1.5) {
                    navigate(.home(.balance))
                }
                // Simulate graph data fluctuations
                withAnimation(.easeInOut(duration: 4)) {
                                animationProgress = 1 // Fully draw the line over 2 seconds
                            }
            }
        }
    }
}

// MARK: - Graph Line Divider Shape
struct GraphLineDivider: Shape {
    var graphPath: [CGFloat]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midHeight = rect.height / 2
        let width = rect.width

        path.move(to: CGPoint(x: 0, y: midHeight))
        for (index, value) in graphPath.enumerated() {
            let x = CGFloat(index) * (width / CGFloat(graphPath.count - 1))
            let y = midHeight + value
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}


