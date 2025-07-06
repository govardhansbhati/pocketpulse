//
//  CardHolderView.swift
//  PocketPulse
//
//  Created by govardhan singh on 05/07/25.
//


import SwiftUI
import Combine

struct CardHolderView: View {
    
    // MARK: Variables
    var gradientColors : [Color]
    var darkText: Bool = false
    
    let widht: CGFloat = UIScreen.main.bounds.width - 48
    let ratioConstant: CGFloat = 1.623
    
    let cornerRadius: CGFloat = 24
    
    
    var body: some View {
        
        let darkTextColor: Color = darkText ? Color.white : Color.black
        
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundStyle(.clear)
            .overlay {
                ZStack {
                    let darkTextColor: Color = darkText ? Color.white : Color.black
                    
                    LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(darkTextColor.opacity(0.125))
                        .offset(y:70)
                        .scaleEffect(1.4)
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(darkTextColor.opacity(0.125))
                        .offset(y:-70)
                        .scaleEffect(1.4)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            .frame(height: widht / ratioConstant)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: 1.25)
                    .foregroundStyle(darkTextColor)
                    .opacity(0.65)
            }
    }
}
