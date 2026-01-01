//
//  IconView.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/01/26.
//

import SwiftUI

struct IconView: View {
    let icon: String // Can be SF Symbol or Asset Name
    var size: CGFloat = AppConstants.Dimension.ContentSize.iconSize
    var color: Color = AppTheme.primaryColor
    var isSystemImage: Bool = true // Defaults to SF Symbol

    var body: some View {
        if isSystemImage {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(color)
        } else {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(color)
        }
    }
}

// Factory method for Button Icons
extension IconView {
    static func onButton(imgName: String, size: CGFloat = AppConstants.Dimension.ContentSize.iconSize) -> IconView {
        return IconView(
            icon: imgName,
            size: size,
            color: AppTheme.onPrimaryColor,
            isSystemImage: true // Assumes buttons use SF Symbols by default; can be adjusted
        )
    }
}
