//
//  AppConstants.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/01/26.
//

import Foundation
import SwiftUI

struct AppConstants {
    
    // MARK: - Layout Dimensions
    struct Validation {
        static let passwordMinLength: Int = 8
    }
    
    struct Currency {
        static let isoCode: String = "INR"
    }
    
    struct Layout {
        static let paddingSmall: CGFloat = 8
        static let paddingMedium: CGFloat = 16
        static let paddingLarge: CGFloat = 24
        static let paddingExtraLarge: CGFloat = 32
        
        static let spacingTiny: CGFloat = 4
        static let spacingSmall: CGFloat = 8
        static let spacingMedium: CGFloat = 12
        static let spacingStandard: CGFloat = 16
        static let spacingLarge: CGFloat = 24
        static let spacingExtraLarge: CGFloat = 32
        
        static let cornerRadiusSmall: CGFloat = 8
        static let cornerRadiusMedium: CGFloat = 12
        static let cornerRadiusLarge: CGFloat = 16
        static let cornerRadiusExtraLarge: CGFloat = 24
        static let cornerRadiusTag: CGFloat = 6
        
        static let borderWidth: CGFloat = 1
        static let borderWidthThick: CGFloat = 1.25
        
        static let shadowRadius: CGFloat = 4
        static let shadowY: CGFloat = 2
        
        static let opacityFaint: Double = 0.125
        static let opacityMedium: Double = 0.65
        static let opacityHigh: Double = 0.9
        
        static let scaleLarge: CGFloat = 1.4
        static let offsetCardCircle: CGFloat = 70
        static let offsetSmall: CGFloat = 2
        static let trackingDefault: CGFloat = 1.1
        
        static let aspectRatioCard: CGFloat = 1.623
        
        static let paddingTagHorizontal: CGFloat = 6
        static let paddingTagVertical: CGFloat = 3
        static let paddingTopNano: CGFloat = 2
    }
    
    // MARK: - Component Specific Sizes
    struct Dimension {
        struct ContentSize {
            static let iconSize: CGFloat = 24
        }
    }

    struct Size {
        static let buttonHeight: CGFloat = 50
        static let iconSmall: CGFloat = 20
        static let iconMedium: CGFloat = 24
        static let iconLarge: CGFloat = 32
        static let iconExtraLarge: CGFloat = 60
        static let providerIconSize: CGFloat = 64
        
        static let cardCarouselHeight: CGFloat = 220
        static let chartHeight: CGFloat = 250
        static let listRowHeight: CGFloat = 40 // For spacers or standard rows
        static let balanceFontSize: CGFloat = 34
        static let cardWidthRatio: CGFloat = 0.8
    }
    
    // MARK: - Durations & Delays
    struct Animation {
        static let standardDuration: Double = 0.3
    }
}
