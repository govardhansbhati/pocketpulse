//
//  AnimatedTabButton.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/04/25.
//

import SwiftUI

struct AnimatedTabButton: View {
    let screen: AppScreen
    let isSelected: Bool
    let action: () -> Void
    @State private var isActive = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 4) {
                screen.icon
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isSelected ? AppTheme.secondaryColor : .gray)
                    // Icon Depth Shadow
                    .shadow(color: isSelected ? AppTheme.secondaryColor.opacity(0.5) : .clear, radius: 5, x: 0, y: 3)
                
                if isSelected {
                    Text(screen.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.secondaryColor)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.2), value: isSelected)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
