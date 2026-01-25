//
//  AppConstants.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/01/26.
//

import Foundation
import SwiftUI

struct AppConstants {
    
    // MARK: - Strings
    struct Strings {
        static let errorTitle = "App Error"
        static let errorStorageMessage = "Storage Error: %@"
        static let errorSafeModeMessage = "The app is running in Safe Mode due to a storage error. Changes may not be saved.\n\nError: %@"
        static let errorUnknown = "Unknown Error"
        static let unknown = "Unknown"
        static let ok = "OK"
        static let criticalStorageFailure = "CRITICAL: Failed to load persistent store: %@"
        static let criticalInMemoryFallbackFailure = "CRITICAL: Could not create in-memory store fallback. Error: %@"
    }
    
    // MARK: - Layout Dimensions
    struct Validation {
        static let passwordMinLength: Int = 8
    }

    struct Opacity {
        static let ultraFaint: Double = 0.05
        static let faint: Double = 0.1
        static let light: Double = 0.2
        static let low: Double = 0.3
        static let dim: Double = 0.5
        static let medium: Double = 0.6
        static let secondary: Double = 0.7
        static let high: Double = 0.8
        static let heavy: Double = 0.9
        
        static let disabled: Double = 0.6
    }
    
    struct Currency {
        static let isoCode: String = "INR"
    }
    
    struct Layout {
        static let paddingNano: CGFloat = 4
        static let paddingTopNano: CGFloat = 2
        static let paddingSmall: CGFloat = 8
        static let paddingTen: CGFloat = 10
        static let paddingMedium: CGFloat = 16
        static let paddingStandard: CGFloat = 20
        static let paddingLarge: CGFloat = 24
        static let paddingExtraLarge: CGFloat = 32
        
        static let headerTopPadding: CGFloat = 60
        static let safeAreaTop: CGFloat = 50
        static let footerBottomPadding: CGFloat = 40
        static let bottomSpacerHeight: CGFloat = 100
        
        static let spacingTiny: CGFloat = 4
        static let spacingSmall: CGFloat = 8
        static let spacingMedium: CGFloat = 12
        static let spacingStandard: CGFloat = 16
        static let spacingLarge: CGFloat = 20
        static let spacingExtraLarge: CGFloat = 24
        
        static let cornerRadiusSmall: CGFloat = 8
        static let cornerRadiusMedium: CGFloat = 12
        static let cornerRadiusLarge: CGFloat = 20
        static let cornerRadiusExtraLarge: CGFloat = 30
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
        
        static let barWidth: CGFloat = 16
        static let cornerRadiusNano: CGFloat = 4
        static let blurRadiusSmall: CGFloat = 2
        static let blurRadiusLarge: CGFloat = 20
        static let shadowRadiusLarge: CGFloat = 10
    }
    
    // MARK: - Component Specific Sizes
    struct Dimension {
        struct ContentSize {
            static let iconSize: CGFloat = 24
        }
    }

    struct Size {
        static let buttonHeight: CGFloat = 50
        static let iconTiny: CGFloat = 18
        static let iconSmall: CGFloat = 20
        static let iconMedium: CGFloat = 24
        static let iconLarge: CGFloat = 32
        static let iconHeader: CGFloat = 36
        static let iconExtraLarge: CGFloat = 60
        static let providerIconSize: CGFloat = 64
        static let profileImageSize: CGFloat = 80
        static let splashIconSize: CGFloat = 100
        
        static let iconContainer: CGFloat = 44
        static let iconContainerSmall: CGFloat = 36
        static let iconContainerTiny: CGFloat = 28
        static let iconProfilePlaceholder: CGFloat = 40
        static let iconMarker: CGFloat = 12
        
        static let passcodeFieldWidth: CGFloat = 200
        
        static let addCardWidth: CGFloat = 60
        static let addCardHeight: CGFloat = 200
        static let cardWidth: CGFloat = 320
        
        static let cardCarouselHeight: CGFloat = 220
        static let chartHeight: CGFloat = 250
        static let listRowHeight: CGFloat = 40
        static let balanceFontSize: CGFloat = 34
        static let cardWidthRatio: CGFloat = 0.8
        static let fontSizeTitleSmall: CGFloat = 18
        static let fontSizeSmall: CGFloat = 14
        
        static let progressBarHeight: CGFloat = 8
        static let progressBarThin: CGFloat = 6
        static let dividerHeight: CGFloat = 1
        static let verticalDividerHeight: CGFloat = 30
    }
    
    // MARK: - Durations & Delays
    struct Animation {
        static let standardDuration: Double = 0.3
        static let damping: Double = 0.7
    }
}
