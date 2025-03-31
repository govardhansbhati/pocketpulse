//
//  TabbarView.swift
//  PocketPulse
//
//  Created by ZMO-MAC-GordhanS-01 on 26/03/25.
//

import SwiftUI

struct TabbarView: View {
    
    @Binding var selection: AppScreen?
    @Namespace private var animationNamespace

    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                }
            }
            .tabViewStyle(.automatic)
            .background(Color.clear)
            
            ZStack {
                
                RoundedRectangleWithArc(cornerRadius: 25, arcRadius: 30)
                                    .fill(Color.white)
                                    .shadow(radius: 5)
                                    .frame(height: 80)
                                    .padding(.horizontal, 20)
                
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
//                .background(RoundedRectangle(cornerRadius: 25)
//                    .fill(Color.white).shadow(radius: 5))
                .padding(.horizontal, 20)
            }
        }
    }
}

struct TabV: View {
    @State var selection: AppScreen? = .home
    var body: some View {
        GeometryReader { geo in
            ZStack {
                TabbarView(selection: $selection)
                ZStack {
                    Circle()
                        .foregroundStyle(Color.white)
                        .frame(width: 55, height: 55)
                        .position(x: geo.size.width / 2.0, y: geo.size.height - 80)
                        .shadow(radius: 4)
                    Button {
                        // Add button Action
                    } label: {
                        Image(systemName: "plus")
                            
                    }
                    
                    .position(x: geo.size.width / 2.0, y: geo.size.height - 80)
                }
            }
        }
        
        
    }
}

#Preview(body: {
    TabV()
})

// Animated Button
struct AnimatedTabButton: View {
    let screen: AppScreen
    let isSelected: Bool
    let action: () -> Void
    @State private var isActive = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack {
                    screen.icon
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(isSelected ? .blue : .gray)
                
                
                if isSelected {
                    Text(screen.title)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.2), value: isSelected)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// Custom Shape: Rounded Rectangle with a Half Arc at the Top Center
struct RoundedRectangleWithArc: Shape {
    var cornerRadius: CGFloat
    var arcRadius: CGFloat

    func path(in rect: CGRect) -> Path {
            var path = Path()
            
        let cutoutWidth = arcRadius * 2
            let centerX = rect.midX
            
            // Start from bottom-left corner
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

            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))

            // Top-right corner
            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(270),
                clockwise: true
            )
        
        path.addLine(to: CGPoint(x: centerX - arcRadius / 2, y: rect.minY))
        
        
        
        // Half Arc at the Top Center
                path.addArc(
                    center: CGPoint(x: centerX, y: rect.minY ),
                    radius: arcRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(180),
                    clockwise: false
                )

                path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        
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
