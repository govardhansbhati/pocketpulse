//
//  CardView.swift
//  PocketPulse
//
//  Created by govardhan singh on 05/07/25.
//


import SwiftUI
import Combine

struct CardView: View {
    
    // MARK: Variable
    var card: Card
    
    var body: some View {
        CardView(card.cardDesign)
            .overlay(alignment: .bottom) {
                // Overlay to render the Card Information
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(card.cardHolderName)
                            .font(.title2)
                            .textCase(.uppercase)
                            .opacity(0.9)
                            .tracking(1.1) //
                        Text(card.cardNumber)
                            .font(.title3)
                            .offset(x:2)
                    }
                    
                    Spacer()
                    
                    Image(card.providerType.rawValue)
                        .resizable()
                        .frame(width: 64, height: 64)
                    
                    // TODO: logo
                    
                }
                .padding()
            }
    }
    
    // MARK: - Functions
    ///
    @ViewBuilder
    func CardView(_ cardDesign: CardDesign) -> some View {
        switch cardDesign {
        case .black:
            CardHolderView(gradientColors: [Color.black,Color.black.opacity(0.85), Color.black], darkText: false)
        case .orange:
            CardHolderView(gradientColors: [Color.orange,Color.orange, Color.red], darkText: true)
        case .pink:
            CardHolderView(gradientColors: [Color.purple,Color.pink, Color.purple], darkText: false)
        }
    }
}
