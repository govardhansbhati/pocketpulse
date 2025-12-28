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
            forResource: base, ofType: ext) != nil, let ui = UIImage(named: name) ?? UIImage(
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
