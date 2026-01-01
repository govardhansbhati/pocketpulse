//
//  GlassCard.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/01/26.
//

import SwiftUI

/// A container view that provides a glassmorphic background effect.
struct GlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                ZStack {
                    // Glass Material
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.6)
                    
                    // Glossy Shine Overlay (Subtle)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.15), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppTheme.glassBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        Color.blue
        GlassCard {
            Text("Glass UI")
                .padding()
                .foregroundStyle(.white)
        }
        .padding()
    }
}
