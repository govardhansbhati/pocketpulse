//
//  CardCarousel.swift
//  PocketPulse
//
//  Created by govardhan singh on 05/01/25.
//
import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let cardNumber: String
    let expiryDate: String
    let cardHolderName: String
    let cardType: String // Debit or Credit
    let backgroundColor: Color
}

struct CardCarouselView: View {
    @State private var currentIndex: Int = 0
    
    let cards: [Card] = [
        Card(cardNumber: "**** **** **** 1234",
             expiryDate: "12/26",
             cardHolderName: "John Doe",
             cardType: "Debit Card",
             backgroundColor: .blue),
        Card(cardNumber: "**** **** **** 5678",
             expiryDate: "01/28",
             cardHolderName: "John Doe",
             cardType: "Credit Card",
             backgroundColor: .purple),
        Card(cardNumber: "**** **** **** 9876",
             expiryDate: "03/27",
             cardHolderName: "John Doe",
             cardType: "Debit Card",
             backgroundColor: .green)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(cards.indices, id: \.self) { index in
                        GeometryReader { proxy in
                            let offset = proxy.frame(in: .global).minY - geometry.size.height / 2
                            let scale = max(1 - abs(offset) / 300, 0.85)
                            
                            CardView(card: cards[index])
                                .scaleEffect(scale)
                                .rotation3DEffect(
                                    .degrees(Double(offset / 15)),
                                    axis: (x: 1, y: 0, z: 0)
                                )
                                .opacity(Double(scale))
                                .padding(.horizontal, 30)
                        }
                        .frame(height: 200)
                    }
                }
                .padding(.vertical, geometry.size.height / 4)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(card.backgroundColor)
                .shadow(color: card.backgroundColor.opacity(0.5), radius: 10, x: 5, y: 5)
            
            VStack(alignment: .leading, spacing: 20) {
                // Card Type
                Text(card.cardType)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Card Number
                Text(card.cardNumber)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                HStack {
                    // Expiry Date
                    VStack(alignment: .leading) {
                        Text("Expiry")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.expiryDate)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    // Card Holder Name
                    VStack(alignment: .leading) {
                        Text("Card Holder")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.cardHolderName)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview{
    CardCarouselView()
}


