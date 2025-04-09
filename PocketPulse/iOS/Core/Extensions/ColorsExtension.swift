//
//  ColorsExtensio.swift
//  PocketPulse
//
//  Created by govardhan singh on 27/12/24.
//

import SwiftUI
import UIKit

extension Color {
    // MARK: - App Theme Colors
    static let primary = Color(dynamicLight: "#4CAF50", dark: "#81C784")        // Green
    static let secondary = Color(dynamicLight: "#FF9800", dark: "#FFB74D")     // Orange
    static let accent = Color(dynamicLight: "#673AB7", dark: "#9575CD")        // Purple
    static let background = Color(dynamicLight: "#F9F9F9", dark: "#121212")    // Light Gray / Dark Background
    
    // MARK: - Font Colors
    static let fontPrimary = Color(dynamicLight: "#212121", dark: "#E0E0E0")   // Main text
    static let fontSecondary = Color(dynamicLight: "#757575", dark: "#BDBDBD") // Subtext
    static let fontAccent = Color(dynamicLight: "#673AB7", dark: "#9575CD")    // Highlight text
    
    // MARK: - Custom Colors
    static let purse = Color(dynamicLight: "#1E3A8A", dark: "#4B6FAB")         // Navy Blue
    static let coin = Color(dynamicLight: "#FFD700", dark: "#FFC107")          // Gold
    
    // MARK: - Transaction Categories
    static let categoryGift = Color(dynamicLight: "#FF6F61", dark: "#FF8A80")       // Gift
    static let categoryGrocery = Color(dynamicLight: "#8BC34A", dark: "#AED581")    // Grocery
    static let categoryTransport = Color(dynamicLight: "#03A9F4", dark: "#64B5F6")  // Transport
    static let categoryHousehold = Color(dynamicLight: "#FF5722", dark: "#FF8A65")  // Household
    static let categoryBill = Color(dynamicLight: "#9E9E9E", dark: "#BDBDBD")       // Bill
    static let categoryLent = Color(dynamicLight: "#FFC107", dark: "#FFD54F")       // Lent
    static let categoryOther = Color(dynamicLight: "#607D8B", dark: "#78909C")      // Other
    
    // MARK: - Shadow Colors
    static let shadow = Color.black.opacity(0.2)       // Default shadow for both themes
}

extension Color {
    init(dynamicLight: String, dark: String) {
        self.init(UIColor { traitCollection in
            let hex = (traitCollection.userInterfaceStyle == .dark) ? dark : dynamicLight
            return UIColor(hex: hex)
        })
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
        scanner.currentIndex = hex.hasPrefix("#") ? hex.index(after: hex.startIndex) : hex.startIndex
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
