//
//  CardView.swift
//  PocketPulse
//
//  Created by govardhan singh on 05/07/25.
//

import Combine
import SwiftUI

struct CardView: View {
    
    var card: CardModel
    
    var body: some View {
        ZStack {
            // MARK: - Card Background & Shape
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: gradientForDesign(card.cardDesign),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: gradientForDesign(card.cardDesign).last!.opacity(0.3), radius: 15, x: 0, y: 10)
            
            // MARK: - Holographic Overlay
            // A diagonal shine that moves slightly
            LinearGradient(
                colors: [.clear, .white.opacity(0.1), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .mask(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .offset(x: -50, y: -50) // Parallax shine static position
            
            // MARK: - Content
            VStack(alignment: .leading) {
                HStack {
                    // Chip
                    Image(systemName: "simcard.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color.yellow.opacity(0.8))
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 1) // Emboss
                    
                    Spacer()
                    
                    // Provider Logo (with glow)
                    if let providerImage = UIImage(named: card.providerType.rawValue) {
                        Image(uiImage: providerImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                            .shadow(color: .white.opacity(0.3), radius: 5)
                    } else {
                         // Fallback SF symbol if asset missing
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
                
                // Card Number
                HStack(spacing: 4) {
                    ForEach(0..<3) { _ in
                        Text("••••")
                            .font(.title3)
                            .fontWeight(.black)
                            .kerning(2)
                    }
                    Text(card.last4Digits)
                        .font(.title3)
                        .fontWeight(.black)
                        .kerning(2)
                }
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1) // Text drop shadow
                
                Spacer()
                
                // Name & Validity
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        AppText.Tiny(text: AppStrings.Wallet.placeholderCardHolder, color: .white.opacity(0.6))
                        Text(card.cardHolderName.uppercased())
                            .font(.system(size: 14,
                                          weight: .bold,
                                          design: .monospaced)) // Keep custom font for card aesthetics
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        AppText.Tiny(text: AppStrings.Wallet.placeholderExpires, color: .white.opacity(0.6))
                        Text(card.expiryDate) 
                            .font(.system(size: 14,
                                          weight: .bold,
                                          design: .monospaced)) // Keep custom font for card aesthetics
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(20)
        }
        .frame(height: 200)
        .saturation(card.status == .active ? 1.0 : 0.0)
        .opacity(card.status == .active ? 1.0 : 0.6)
        .overlay(
            Group {
                if card.status != .active {
                    Text(card.status.rawValue.uppercased())
                        .font(.system(size: 24,
                                      weight: .bold,
                                      design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                        .rotationEffect(.degrees(-15))
                }
            }
        )
        // MARK: - 3D Tilt Effect
        // Rotation is now handled by the parent ScrollView's phase transition for better performance and no conflict.

    }
    
    func gradientForDesign(_ design: CardDesign) -> [Color] {
        switch design {
        case .black:
            return [Color(hex: "000000"), Color(hex: "434343")]
        case .orange:
            return [Color(hex: "FF416C"), Color(hex: "FF4B2B")] // Sunset
        case .pink:
            return [Color(hex: "8E2DE2"), Color(hex: "4A00E0")] // Electric Purple
        }
    }
}
