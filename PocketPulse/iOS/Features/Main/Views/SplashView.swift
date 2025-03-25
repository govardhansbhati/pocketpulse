//
//  SplashView.swift
//  PocketPulse
//
//  Created by ZMO-MAC-GordhanS-01 on 19/03/25.
//

import SwiftUI

struct SplashView: View {
    
    @Environment(\.navigateRoute) private var navigateRoute
    
    @State private var isAnimating = false
    @State private var moveCoinUp = false
    @State private var moveCoinDown = false
    @State private var animationProgress: CGFloat = 0
    @State private var graphPath: [CGFloat] = [0, 10, -5, 15, -10, 5, 8, 12, -6, 10, -5, 15, 12, -6, 3]
    
    @Binding var navigateToTab: Bool
    
    let imageCount = 6
    let animationDuration: Double = 2
    let delayBetwnCoins: Double = 0.1
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let imageSize = screenWidth / 4
            let size = min(geometry.size.width, geometry.size.height) / 2
            ZStack {
                // Background Color
                Color(UIColor.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                
                ForEach(0..<imageCount, id: \.self) {index in
                    // Rotating image
                    Image(systemName: "indianrupeesign.circle.fill")
                        .resizable()
                        .frame(width: imageSize / 2, height: imageSize / 2)
                        .foregroundStyle(Color.gray.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                        .offset(y: moveCoinUp ? -size / 2 : 0)
                        .offset(y: moveCoinDown ? size / 2 : 0)
                        .animation(.easeInOut(duration: 1).delay(Double(index) * delayBetwnCoins), value: moveCoinUp)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0), anchor: .center)
                        .animation(Animation.easeInOut(duration: animationDuration)
                            .delay(Double(index) * delayBetwnCoins), value: isAnimating)
                        .animation(.easeInOut(duration: 1).delay(Double(index) * delayBetwnCoins), value: moveCoinDown)
                }
                
                // Centered Wallet image
                Image(systemName: "wallet.bifold.fill")
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .symbolEffect(.pulse.wholeSymbol, options: .nonRepeating, value: moveCoinUp)
                    .symbolEffect(.pulse.wholeSymbol, options: .nonRepeating, value: moveCoinDown)
                    .foregroundStyle(.brown)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 4, y: 4)
                
                
                ZStack {
                    Text("PocketPulse")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Color.black) // Font color
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5) // Shadow for depth
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1) // Border for subtle depth
                                )
                        )
                }
                .offset(y: moveCoinUp ? size : 0)
                .onTapGesture {
                    
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                moveCoinUp = true
                let upTime = (Double(imageCount) * delayBetwnCoins) + 1
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime) {
                    isAnimating = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime * 2 + 0.5) {
                    moveCoinDown = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime * 2 + 3.5) {
                    print("Navigating to tab")
                    navigateToTab = true
                }
                // Simulate graph data fluctuations
                withAnimation(.easeInOut(duration: 4)) {
                    animationProgress = 1 // Fully draw the line over 2 seconds
                }
            }
        }
    }
}
