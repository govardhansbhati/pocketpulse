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
