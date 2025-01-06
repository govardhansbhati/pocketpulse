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
            TabView(selection: $currentIndex) {
                ForEach(cards.indices, id: \.self) { index in
                    CardView(card: cards[index], geometry: geometry)
                        .rotation3DEffect(
                            .degrees(currentIndex == index ? 0 : currentIndex > index ? -20 : 20),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .padding(.horizontal, 40)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentIndex)
        }
    }
}

struct CardView: View {
    let card: Card
    let geometry: GeometryProxy
    
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
        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
    }
}

#Preview{
    CardCarouselView()
}


