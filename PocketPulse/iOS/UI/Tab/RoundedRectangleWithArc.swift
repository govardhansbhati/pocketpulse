//
//  RoundedRectangleWithArc.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/04/25.
//


import SwiftUI

struct RoundedRectangleWithArc: Shape {
    // Corner radius for the outer rounded rectangle
    var cornerRadius: CGFloat
    // Normalized expansion progress: 0 (collapsed) ... 1 (fully expanded)
    var isExtendPlus: CGFloat
    // Optional anchor X in the shape's coordinate space to align with the plus button's center.
    // If not provided by caller, we default to rect.midX inside path(in:).
    var anchorX: CGFloat?

    // Animatable: drive only expansion smoothly
    var animatableData: CGFloat {
        get { isExtendPlus }
        set { isExtendPlus = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Ensure normalized progress
        let t = max(0, min(1, isExtendPlus))

        // Resolve anchor X (center of the top arc pair). If not supplied, use rect.midX
        let baseCenterX = anchorX ?? rect.midX

        // Compute safe horizontal bounds to avoid overlapping the top-left/right corner arcs
        // Keep some spacing from the corners
        let minGap: CGFloat = 36
        // For larger screens (like iPad), we want the curve to be proportional, not clamped small.
        // We use a base width reference.
        let minWidth: CGFloat = 320
        let maxWidth: CGFloat = 430
        
        // Calculate gap based on width
        let comfortGap: CGFloat
        if rect.width <= maxWidth {
            let widthT = max(0, min(1, (rect.width - minWidth) / (maxWidth - minWidth)))
            comfortGap = minGap + (55 - minGap) * widthT
        } else {
            // For screens wider than standard Max phones, scale gracefully
            comfortGap = 55 + (rect.width - maxWidth) * 0.15
        }

        let leftBound = rect.minX + cornerRadius + comfortGap
        let rightBound = rect.maxX - cornerRadius - comfortGap

        // Max horizontal travel from the center without crossing into the corners
        let maxTravel = max(0, min(rightBound - rect.midX, rect.midX - leftBound))

        // Extension factor based on normalized t
        let extensionFactor = t * maxTravel

        // Compute centers for the two top arcs
        let centerRightX = baseCenterX + extensionFactor
        let centerLeftX  = baseCenterX - extensionFactor

        // Arc radius uses cornerRadius
        let arcRadius = cornerRadius

        // Begin path construction
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

        // Top edge center arcs (ensure we don't exceed bounds by clamping centers)
        let clampedRightX = min(max(centerRightX, leftBound), rightBound)
        let clampedLeftX  = min(max(centerLeftX, leftBound), rightBound)

        // Right center arc
        path.addArc(
            center: CGPoint(x: clampedRightX, y: rect.minY),
            radius: arcRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        // Left center arc
        path.addArc(
            center: CGPoint(x: clampedLeftX, y: rect.minY),
            radius: arcRadius,
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

