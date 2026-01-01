//
//  BackgroundView.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/01/26.
//

import SwiftUI

/// A global animated background view creating a "Mesh Atmosphere" effect.
struct BackgroundView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base Color
            // Base Color with Tint for cohesion
            Rectangle()
                .fill(AppTheme.backgroundColor)
                .overlay(
                    LinearGradient(
                        colors: [
                            AppTheme.primaryColor.opacity(0.05),
                            AppTheme.secondaryColor.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
            
            // Floating Orbs
            GeometryReader { geometry in
                ZStack {
                    // Orb 1: Primary Purple
                    Circle()
                        .fill(AppTheme.primaryColor.opacity(0.4))
                        .frame(width: geometry.size.width * 0.8)
                        .blur(radius: 60)
                        .offset(x: animate ? -30 : 30, y: animate ? -30 : 30)
                        .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.2)
                    
                    // Orb 2: Secondary Violet
                    Circle()
                        .fill(AppTheme.secondaryColor.opacity(0.4))
                        .frame(width: geometry.size.width * 0.7)
                        .blur(radius: 60)
                        .offset(x: animate ? 20 : -20, y: animate ? 40 : -40)
                        .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.8)
                    
                    // Orb 3: Mint Accent (Income)
                    Circle()
                        .fill(AppTheme.income.opacity(0.3))
                        .frame(width: geometry.size.width * 0.5)
                        .blur(radius: 50)
                        .offset(x: animate ? -50 : 50, y: animate ? 20 : -20)
                        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                }
            }
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
            
            // Noise Overlay for Texture (Optional, adds premium feel)
            // Color.white.opacity(0.02).blendMode(.overlay)
        }
    }
}

#Preview {
    BackgroundView()
}
