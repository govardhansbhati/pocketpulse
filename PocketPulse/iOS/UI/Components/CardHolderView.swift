//
//  CardHolderView.swift
//  PocketPulse
//
//  Created by govardhan singh on 05/07/25.
//

import SwiftUI
import Combine

struct CardHolderView: View {
    var gradientColors: [Color]
    var darkText: Bool = false

    let cornerRadius: CGFloat = AppConstants.Layout.cornerRadiusExtraLarge
    
    var body: some View {
        let darkTextColor: Color = darkText ? Color.white : Color.black
        
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundStyle(.clear)
            .overlay {
                ZStack {
                    LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    Circle()
                        .stroke(lineWidth: AppConstants.Layout.borderWidth)
                        .foregroundStyle(darkTextColor.opacity(AppConstants.Layout.opacityFaint))
                        .offset(y: AppConstants.Layout.offsetCardCircle)
                        .scaleEffect(AppConstants.Layout.scaleLarge)
                    Circle()
                        .stroke(lineWidth: AppConstants.Layout.borderWidth)
                        .foregroundStyle(darkTextColor.opacity(AppConstants.Layout.opacityFaint))
                        .offset(y: -AppConstants.Layout.offsetCardCircle)
                        .scaleEffect(AppConstants.Layout.scaleLarge)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            
            .aspectRatio(AppConstants.Layout.aspectRatioCard, contentMode: .fit) // Maintain aspect ratio
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: AppConstants.Layout.borderWidthThick)
                    .foregroundStyle(darkTextColor)
                    .opacity(AppConstants.Layout.opacityMedium)
            }
    }
}
