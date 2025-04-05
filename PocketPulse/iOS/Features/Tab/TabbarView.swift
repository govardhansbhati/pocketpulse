//
//  TabbarView.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI

struct TabbarView: View {
    
    @State var selection: AppScreen = .home
    @StateObject var colorManager = BackgroundColorManager()
    @Binding var plusTapped: Bool
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                }
            }
            .background(Color.clear)
            .tabViewStyle(.automatic)
            
            ZStack {
                
                RoundedRectangleWithArc(cornerRadius: 25, isExtendPlus: plusTapped ? 1 : 0)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(height: 80)
                    .padding(.horizontal, 20)
                    .animation(.easeInOut(duration: 0.3), value: plusTapped)
                
                HStack {
                    ForEach(AppScreen.allCases) { screen in
                        AnimatedTabButton(screen: screen, isSelected: selection == screen) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selection = screen
                            }
                        }
                    }
                }
                .frame(height: 80)
                .padding(.horizontal, 20)
            }
        }
        .environmentObject(colorManager)
    }
}

struct TabV: View {
    @State private var progress: CGFloat = 0.25
    @State var plusTapped: Bool = false
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    TabbarView( plusTapped: $plusTapped)
                    ZStack {
                        RoundedRectangleShape(cornerRadius: plusTapped ? 15 : geo.size.width / 2)
                            .foregroundStyle(Color.white)
                            .frame(width: plusTapped ? (geo.size.width / 2) + 65 : 55, height: plusTapped ? 65 : 55) // Slightly wider for rectangle effect
                            .position(x: geo.size.width / 2.0, y: geo.size.height - (plusTapped ? 100 : 80))
                            .shadow(radius: 4)
                            .animation(.easeInOut(duration: 0.5), value: plusTapped)
                        Rectangle()
                            .foregroundStyle(Color.blue)
                            .frame(width: 2, height: plusTapped ? 65 : 20)
                            .animation(.easeInOut(duration: 0.5), value: plusTapped)
                            .position(x: geo.size.width / 2.0, y: geo.size.height - (plusTapped ? 100 : 80))
                        Rectangle()
                            .foregroundStyle(Color.blue)
                            .frame(width: plusTapped ? 0 : 20, height: 2)
                            .position(x: geo.size.width / 2.0, y: geo.size.height - (plusTapped ? 100 : 80))
                        
                        RoundedRectangleShape(cornerRadius: 15)
                            .trim(from: 0.25, to: progress) // Trim the stroke
                            .stroke(Color.blue, lineWidth: 1.5)
                            .rotationEffect(.degrees(180))
                            .frame(width:  (geo.size.width / 2) + 65, height: 65)                            .position(x: geo.size.width / 2.0, y: geo.size.height - (100))
                            .animation(.easeInOut(duration: 2), value: progress)
                        RoundedRectangleShape(cornerRadius: 15)
                            .trim(from: 0.25, to: progress) // Trim the stroke
                            .stroke(Color.blue, lineWidth: 1.5)
//                            .rotationEffect(.degrees(180))
                            .frame(width:  (geo.size.width / 2) + 65, height: 65)                            .position(x: geo.size.width / 2.0, y: geo.size.height - (100))
                            .animation(.easeInOut(duration: 2), value: progress)
                        
                        HStack {
                            Spacer()
                            Button {
                                // Add button Action
                                plusTapped.toggle()
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    progress = 0.75
                                }
                            } label: {
                                Text("Add Expense")
                            }
                            Spacer()
                            Button {
                                // Add button Action
                                plusTapped.toggle()
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    progress = 0.75
                                }
                            } label: {
                                Text("Add Income")
                            }
                            Spacer()
                        }
                        .frame(width: (geo.size.width / 2) + 65 , height: 55)
                        .position(x: geo.size.width / 2.0, y: geo.size.height - (100))
                        
                        Button {
                            // Add button Action
                            plusTapped.toggle()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                progress = 0.75
                            }
                        } label: {
                            Color.clear
                                .frame(width: 80, height: 80)
                        }
                        .position(x: geo.size.width / 2.0, y: geo.size.height - 80)
                    }
                }
            }
        }
    }
}

#Preview(body: {
    TabV()
})



struct RoundedRectangleWithArc: Shape {
    var cornerRadius: CGFloat
    var isExtendPlus: CGFloat // Animatable property

    var animatableData: CGFloat {
        get { isExtendPlus }
        set { isExtendPlus = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let centerX = rect.midX

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
        
        // Bottom-left corner
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )
        
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))

        // Bottom-right corner
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )
        
        // Top-right corner
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(270),
            clockwise: true
        )

        // Smooth transition between normal and extended states
        let extensionFactor = isExtendPlus * ((rect.maxX - 60) - rect.midX)
        let dynamicRadius = 15 + (15 * (1 - isExtendPlus))
        let centerRightX = centerX + extensionFactor
        let centerLeftX = centerX - extensionFactor
        // center right arc
        path.addArc(
            center: CGPoint(x: centerRightX, y: rect.minY),
            radius: dynamicRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        // center left arc
        path.addArc(
            center: CGPoint(x: centerLeftX, y: rect.minY),
            radius: dynamicRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        // Top-left corner
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(180),
            clockwise: true
        )

        path.closeSubpath()

        return path
    }
}


struct RoundedRectangleShape: Shape {
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { cornerRadius }
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path(roundedRect: rect, cornerRadius: cornerRadius)
    }
}
