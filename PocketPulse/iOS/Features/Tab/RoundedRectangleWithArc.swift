//
//  RoundedRectangleWithArc.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/04/25.
//


import SwiftUI

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
