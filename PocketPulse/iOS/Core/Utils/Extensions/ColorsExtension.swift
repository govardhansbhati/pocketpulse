//
//  ColorsExtensio.swift
//  PocketPulse
//
//  Created by govardhan singh on 27/12/24.
//

import SwiftUI
import UIKit

extension Color {
    // MARK: - Custom Utility Colors
    static let shadow = Color.black.opacity(0.2)
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
