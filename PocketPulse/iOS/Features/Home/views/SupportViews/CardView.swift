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
        CardHolderView(gradientColors: gradientForDesign(card.cardDesign), darkText: false)
            .overlay(alignment: .bottom) {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(card.cardHolderName)
                            .font(.title2)
                            .textCase(.uppercase)
                            .opacity(0.9)
                            .tracking(1.1)
                        Text(card.cardNumber)
                            .font(.title3)
                            .offset(x: 2)
                    }
                    Spacer()
                    Image(card.providerType.rawValue)
                        .resizable()
                        .frame(width: 64, height: 64)
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
