//
//  AppTheme.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/01/26.
//

import SwiftUI

struct AppTheme {
    // MARK: - Colors
    static let primaryColor = Color(hex: "4A00E0") // Deep Purple
    static let onPrimaryColor = Color.white
    static let secondaryColor = Color(hex: "8E2DE2") // Neon Violet
    static let backgroundColor = Color("BackgroundColor") // Asset or System
    // MARK: - Semantic Colors
    static let income = Color(hex: "00F5A0") // Neon Mint
    static let expense = Color(hex: "FF4D4D") // Neon Coral
    static let textDark = Color.white
    static let textLight = Color(hex: "1A1A2E") // Deep Navy
    static let adaptiveText = Color("AdaptiveText") // Adaptive: Navy (Light) / White (Dark)
    
    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "4A00E0"), Color(hex: "8E2DE2")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let glassBorder = LinearGradient(
        colors: [.white.opacity(0.5), .white.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}
