//
//  CardView.swift
//  PocketPulse
//
//  Created by govardhan singh on 05/07/25.
//


import SwiftUI
import Combine

struct CardView: View {
    
    var card: CardModel
    
    var body: some View {
        CardHolderView(gradientColors: gradientForDesign(card.cardDesign), darkText: card.cardDesign == .black)
            .overlay(alignment: .bottom) {
                HStack {
                    VStack(alignment: .leading, spacing: AppConstants.Layout.spacingMedium) {
                        Text(card.cardHolderName)
                            .foregroundStyle(card.cardDesign == .black ? Color.white : Color.black)
                            .font(.title2)
                            .textCase(.uppercase)
                            .opacity(AppConstants.Layout.opacityHigh)
                            .tracking(AppConstants.Layout.trackingDefault)
                        Text("**** **** **** " + card.last4Digits)
                            .foregroundStyle(card.cardDesign == .black ? Color.white : Color.black)
                            .font(.title3)
                            .offset(x: AppConstants.Layout.offsetSmall)
                    }
                    Spacer()
                    Image(card.providerType.rawValue)
                    .resizable()
                    .frame(width: AppConstants.Size.providerIconSize, height: AppConstants.Size.providerIconSize)
                }
                .padding()
            }
    }
    
    func gradientForDesign(_ design: CardDesign) -> [Color] {
        switch design {
        case .black:
            return [Color.black, Color.black.opacity(0.85), Color.black]
        case .orange:
            return [Color.orange, Color.orange, Color.red]
        case .pink:
            return [Color.purple, Color.pink, Color.purple]
        }
    }
}
