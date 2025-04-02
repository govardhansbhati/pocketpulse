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
                
                RoundedRectangleWithArc(cornerRadius: 25, arcRadius: 30, isExtendPlus: plusTapped)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(height: 80)
                    .padding(.horizontal, 20)
                    .animation(.easeInOut(duration: 1.9), value: plusTapped)
                
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
    //    @State var selection: AppScreen? = .home
    @State var plusTapped: Bool = false
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    TabbarView( plusTapped: $plusTapped)
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.white)
                            .frame(width: 55, height: 55)
                            .position(x: geo.size.width / 2.0, y: geo.size.height - 80)
                            .shadow(radius: 4)
                        Button {
                            // Add button Action
                            withAnimation { // Wrap the state change in withAnimation
                                plusTapped.toggle()
                            }
                        } label: {
                            Image(systemName: "plus")
                        }
                        
                        .position(x: geo.size.width / 2.0, y: geo.size.height - 80)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    print("Left button tapped")
                }) {
                    Image(systemName: "list.bullet")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Right button tapped")
                }) {
                    Text("UUU")
                
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
    var arcRadius: CGFloat
    var isExtendPlus: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
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
        
        // Code for extend +
        if isExtendPlus {
            path.addLine(to: CGPoint(x: rect.maxX - (cornerRadius + 20), y: rect.minY))
            
            path.addArc(
                center: CGPoint(x: rect.maxX - (15 + 40) , y: rect.minY),
                radius: 15,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )
            
            
            path.addArc(
                center: CGPoint(x: rect.minX + (15 + 40) , y: rect.minY),
                radius: 15,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: false
            )
        }
        else {
            // Half Arc at the Top Center
            path.addArc(
                center: CGPoint(x: centerX, y: rect.minY ),
                radius: arcRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(180),
                clockwise: false
            )
    
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        }
        
        
        
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
