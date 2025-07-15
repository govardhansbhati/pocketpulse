//
//  ViewExtension.swift
//  PocketPulse
//
//  Created by govardhan singh on 15/07/25.
//

import SwiftUI

struct NeumorphicStyle: ViewModifier {
    var cornerRadius: CGFloat = 15
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var shadowRadius: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(color: .white, radius: shadowRadius, x: -5, y: -5)
                    .shadow(color: .black.opacity(0.2), radius: shadowRadius, x: 5, y: 5)
            )
    }
}


extension View {
    func neumorphicStyle(
            cornerRadius: CGFloat = 15,
            backgroundColor: Color = Color.gray.opacity(0.2),
            shadowRadius: CGFloat = 10
        ) -> some View {
            self.modifier(
                NeumorphicStyle(
                    cornerRadius: cornerRadius,
                    backgroundColor: backgroundColor,
                    shadowRadius: shadowRadius
                )
            )
        }
}


struct GlassStyle: ViewModifier {
    var cornerRadius: CGFloat = 25
    var blur: CGFloat = 4
    var opacity: Double = 0.15
    var shadowColor: Color = .black.opacity(0.25)
    var shadowRadius: CGFloat = 20
    var shadowOffsetY: CGFloat = 10
    var borderColor: Color = Color.white.opacity(0.3)
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                // Layered blur + translucency + material
                Color.white.opacity(opacity)
                    .background(.ultraThinMaterial)
                    .blur(radius: blur)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1.2)
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffsetY)
    }
}

extension View {
    func glassStyle(
        cornerRadius: CGFloat = 15,
        blur: CGFloat = 4,
        opacity: Double = 0.2
    ) -> some View {
        self.modifier(GlassStyle(cornerRadius: cornerRadius, blur: blur, opacity: opacity))
    }
}
