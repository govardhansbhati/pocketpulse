//
//  DiagonalWaveBackgroundView.swift
//  PocketPulse
//
//  Created by govardhan singh on 04/01/25.
//

import SwiftUI

struct DiagonalWaveBackgroundView: View {
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.accent, Color.secondary]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea() // Covers the entire screen
            
            // Diagonal Wave Shape
            WaveShape()
                .fill(Color.white.opacity(0.2)) // Wave color with transparency
                .rotationEffect(.degrees(180)) // Invert wave for diagonal look
                .offset(y: 200) // Adjust position of the wave
        }
    }
}

// MARK: - Wave Shape
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Starting point
        path.move(to: CGPoint(x: 0, y: rect.height * 0.75))
        
        // Wave curve
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.25),
            control1: CGPoint(x: rect.width * 0.3, y: rect.height),
            control2: CGPoint(x: rect.width * 0.7, y: 0)
        )
        
        // Bottom-right corner
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        // Bottom-left corner
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        // Close the path
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    DiagonalWaveBackgroundView()
}

