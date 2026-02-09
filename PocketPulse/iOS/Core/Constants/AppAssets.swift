//
//  AppAssets.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 14/12/25.
//

import Foundation
import SwiftUI

/// This enum contains the names of system images used in the app.
enum AppAssets {

    static let imgPlaceholder = "AppIcon"
    
    enum Icons {
        static let personCircleFill = "person.circle.fill"
        static let bellFill = "bell.fill"
        static let bellSlashFill = "bell.slash.fill"
        static let infoCircle = "info.circle"
        static let creditCardFill = "creditcard.fill"
        static let docTextMagnifyingGlass = "doc.text.magnifyingglass"
        static let trash = "trash"
        
        // Navigation & Tab Icons
        static let houseFill = "house.fill"
        static let chartPieFill = "chart.pie.fill"
        static let listBulletRectanglePortraitFill = "list.bullet.rectangle.portrait.fill"
        static let walletPassFill = "wallet.pass.fill"
        
        // Profile & Settings
        static let personCropCircleFill = "person.crop.circle.fill"
        static let personFill = "person.fill"
        static let personCropCircle = "person.crop.circle"
        static let person2Slash = "person.2.slash"
        static let clockArrowCirclepath = "clock.arrow.circlepath"
        static let lockShieldFill = "lock.shield.fill"
        static let icloudAndArrowDownFill = "icloud.and.arrow.down.fill"
        static let starFill = "star.fill"
        static let chevronLeftSlashChevronRight = "chevron.left.slash.chevron.right"
        static let chevronRight = "chevron.right"
        static let squareAndArrowUp = "square.and.arrow.up"
        static let chevronLeft = "chevron.left"
        static let xmarkCircleFill = "xmark.circle.fill"
        static let docTextFill = "doc.text.fill"
        static let arrowUpRight = "arrow.up.right"
        static let arrowDownLeft = "arrow.down.left"
        static let building2Fill = "building.2.fill"
        static let link = "link"
        static let calendarBadgeExclamationmark = "calendar.badge.exclamationmark"
        static let numberSquareFill = "number.square.fill"
        static let circleFill = "circle.fill"
        static let calendar = "calendar"
        static let clockFill = "clock.fill"
        
        // Statics & Charts
        static let calendarBadgeClock = "calendar.badge.clock"
        static let chartBarXaxis = "chart.bar.xaxis"
        static let chartXYAxisLine = "chart.xyaxis.line"
        
        // Wallet & Finance
        static let indianrupeesignCircleFill = "indianrupeesign.circle.fill"
        static let walletBifoldFill = "wallet.bifold.fill"
        static let buildingColumnsFill = "building.columns.fill"
        
        // Common / UI
        static let arrowDown = "arrow.down"
        static let arrowUp = "arrow.up"
        static let paperplaneFill = "paperplane.fill"
        static let plus = "plus"
    }
    
}

// MARK: - AppAssets Helper Methods
extension AppAssets {
    
    /// Checks if the given name corresponds to a valid SF Symbol.
    /// - Parameter name: The name of the symbol to check.
    /// - Returns: `true` if the name is a valid SF Symbol, otherwise `false`.
    static func isSFSymbol(_ name: String) -> Bool {
        return UIImage(systemName: name) != nil
    }
    
    /// Checks if an image exists in the app's asset catalog.
    /// - Parameter name: The name of the image to check.
    /// - Returns: `true` if the image exists in assets, otherwise `false`.
    static func imageExistsInAssets(named name: String?) -> Bool {
        guard let name = name, !name.isEmpty else { return false }
        return UIImage(named: name) != nil
    }
    
    /// Checks if an image exists at the specified file path.
    /// - Parameter path: The file path to check.
    /// - Returns: `true` if an image exists at the path, otherwise `false`.
    static func imageExistsAtFilePath(_ path: String) -> Bool {
        guard FileManager.default.fileExists(atPath: path) else { return false }
        return UIImage(contentsOfFile: path) != nil
    }
    
    /// Returns an Image for the given name or a placeholder if not found.
    /// - Parameters:
    ///   - name: The name of the image to load.
    ///   - placeholder: The name of the placeholder image to use if the image is not found. Defaults to `AppAssets.imgPlaceholder`.
    /// - Returns: A SwiftUI Image.
    static func image(named name: String?, placeholder: String = AppAssets.imgPlaceholder) -> Image {
        guard let name = name, !name.isEmpty else { return Image(placeholder) }

        // 1. Asset catalog / bundle image by name
        if UIImage(named: name) != nil {
            return Image(name)
        }

        // 2. File in bundle (with extension)
        let nameStr = (name as NSString)
        let ext = nameStr.pathExtension.isEmpty ? nil : nameStr.pathExtension
        let base = nameStr.deletingPathExtension
        if Bundle.main.path(
            forResource: base, ofType: ext) != nil,
           let ui = UIImage(named: name) ?? UIImage(
                contentsOfFile: Bundle.main.path(forResource: base, ofType: ext) ?? ""
           ) {
            return Image(uiImage: ui)
        }

        // 3. File on disk (absolute path)
        if FileManager.default.fileExists(atPath: name),
           let ui = UIImage(contentsOfFile: name) {
            return Image(uiImage: ui)
        }

        // 4. SF Symbol
        if UIImage(systemName: name) != nil {
            return Image(systemName: name)
        }

        // fallback
        return Image(placeholder)
    }
}
