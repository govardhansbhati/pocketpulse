//
//  Bundle+Extension.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 22/02/26.
//

import Foundation

extension Bundle {
    var displayName: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
               object(forInfoDictionaryKey: "CFBundleName") as? String ??
               "My App"
    }
}
