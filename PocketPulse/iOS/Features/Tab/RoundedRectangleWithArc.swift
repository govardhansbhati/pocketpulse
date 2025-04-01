//
//  RoundedRectangleWithArc.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/04/25.
//


import SwiftUI

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
