//
//  CardCarousel.swift
//  PocketPulse
//
//  Created by govardhan singh on 05/01/25.
//
import SwiftUI
import Combine

//struct CardCarouselView: View {
//    @State private var cardViewModel: CardViewModel = .init()
//    @State private var viewAppeared = false
//    
//    @State private var stackCards = true // stack the card on top of each other
//    @State private var yOffSet: CGFloat = 0 // offset to move the card wiht the gesture
//    @State private var activeCardIndex = -1
//    
//    let animatationDuration: TimeInterval = 0.35
//    let width: CGFloat = UIScreen.main.bounds.width - 48
//    
//    let ratioConstant: CGFloat = 1.623
//    
//    let dragOffset: CGFloat = 120
//    
//    // MARK: Views
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            Color(UIColor.systemBackground)
//                .ignoresSafeArea()
//            
//            VStack(alignment: .leading) {
//                GenerateTopHeaderView()
//                
//                
//                // another vstack for the cards
//                
//                VStack(alignment: .leading) {
//                    ForEach(Array(zip(cardViewModel.cards.indices, cardViewModel.cards)), id: \.1.id) { ix, card in
//                        CardView(card: card)
//                        
//                        // first we'll use the offset modifier to stack the cards
//                            .offset(y: stackCards && ix != 0 ? -((width / ratioConstant) - 16) * CGFloat(ix) : 0)
//                        
//                        // next we'll use another modifier to apply the yOffset to the current dragging card
//                            .offset(y: ix == activeCardIndex ? yOffSet : 0)
//                        
//                        // we'll use a ZIndex to prioritise the visibility of the last card
//                            .zIndex(10.0 + Double(ix))
//                            .gesture(getDragGesture(ix))
//                    }
//                }
//            }
//            .padding(.horizontal, 24)
//            .padding(.top, 12)
//        }
//    }
//    
//    // MARK: Function
//    /// Function to generate the top header view
//    
//    @ViewBuilder
//    func GenerateTopHeaderView() -> some View {
//        
//        Text("Wallet").tracking(1.1)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .overlay(alignment:.trailing) {
//                Button {
//                    withAnimation(.smooth) {
//                        stackCards.toggle()
//                    }
//                } label: {
//                    Image(systemName: "arrow.up.arrow.down")
//                }
//                .symbolEffect(.bounce.byLayer, options: .speed(1.2),value: stackCards)
//                .buttonStyle(.plain)
//            }
//    }
//    
//    // Drag Gesture for the card view
//    
//    func getDragGesture(_ ix: Int) -> some Gesture {
//        // MARK: Todo : commenting drag logic
////        DragGesture(minimumDistance: 32, coordinateSpace: .local)
////            .onChanged { value in
////                // Only allow the drag on the last card, and if cards are stacked i.e. -> stackCards == true
////                guard ix == $cardViewModel.car.count - 1 , stackCards else { return }
////                
////                // set the currently active car
////                activeCardIndex = ix
////                
////                let translationY = value.translation.height
////                
////                // Restrict the drag beyond certain threshold
////                guard !(translationY > 0 && yOffSet > dragOffset) else { return }
////                
////                // Animation  yOffset with the animation block
////                withAnimation(.smooth) {
////                    yOffSet = Double(translationY)
////                }
////            }
//        
//        // we'll  swap the card with the help of cardViewModel function, and the onEnded function of DragGestre
//            .onEnded { value in
//                // If the drag is significant in either direction, w'll shift the card
//                if (abs(yOffSet) > dragOffset) {
//                    cardViewModel.shiftCard()
//                }
//                
//                // Reset the offSet otherwise
//                withAnimation(.snappy(duration: animatationDuration)) {
//                    activeCardIndex = -1
//                    yOffSet = 0
//                }
//            }
//    }
//}

//#Preview{
//    CardCarouselView()
//}

