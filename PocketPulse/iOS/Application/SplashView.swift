//
//  SplashView.swift
//  PocketPulse
//
//  Created by govardhan singh on 19/03/25.
//

import SwiftUI

/// A view that displays an animated splash screen when the app launches.
struct SplashView: View {
    
    // MARK: - Properties
    
    let appDI: AppDI
    
    // --- State for Animations ---
    /// A flag to trigger the main rotation animation.
    @State private var isAnimating = false
    /// A flag to control the upward movement of the coins.
    @State private var moveCoinUp = false
    /// A flag to control the downward movement of the coins.
    @State private var moveCoinDown = false
    
    /// Checks for passcode state
    @AppStorage("isPasscodeEnabled") private var isPasscodeEnabled: Bool = false
    
    // --- Animation Constants ---
    /// The number of coin images to animate.
    let imageCount = 6
    /// The duration of the main rotation animation.
    let animationDuration: Double = 2
    /// The delay between each coin's animation, creating a staggered effect.
    let delayBetwnCoins: Double = 0.1
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            // Use GeometryReader to get the screen dimensions for responsive layout.
            let screenWidth = geometry.size.width
            let imageSize = screenWidth / 4
            let verticalOffset = min(geometry.size.width, geometry.size.height) / 2
            
            ZStack {
                // Background
                AppTheme.backgroundColor.ignoresSafeArea()
                
                // Animating Coins
                ForEach(0..<imageCount, id: \.self) { index in
                    Image(systemName: AppAssets.Icons.indianrupeesignCircleFill)
                        .resizable()
                        .frame(width: imageSize / 2, height: imageSize / 2)
                        .foregroundStyle(Color.white.opacity(0.8))
                        .shadow(color: AppTheme.primaryColor.opacity(0.3), radius: 5, x: 0, y: 2)
                    // Animate the coin moving up and then down.
                        .offset(y: moveCoinUp ? -verticalOffset / 2 : 0)
                        .offset(y: moveCoinDown ? verticalOffset / 2 : 0)
                    // The main rotation animation for the coins.
                        .rotationEffect(.degrees(isAnimating ? 360 : 0), anchor: .center)
                    // Apply separate, staggered animations for each movement.
                        .animation(.easeInOut(duration: 1).delay(Double(index) * delayBetwnCoins), value: moveCoinUp)
                        .animation(Animation.easeInOut(duration: animationDuration).delay(Double(index) * delayBetwnCoins), value: isAnimating)
                        .animation(.easeInOut(duration: 1).delay(Double(index) * delayBetwnCoins), value: moveCoinDown)
                }
                
                // Centered Wallet Image
                Image(systemName: AppAssets.Icons.walletBifoldFill)
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                // The wallet pulses when the coins move.
                    .symbolEffect(.pulse.wholeSymbol, options: .nonRepeating, value: moveCoinUp)
                    .symbolEffect(.pulse.wholeSymbol, options: .nonRepeating, value: moveCoinDown)
                    .foregroundStyle(AppTheme.primaryGradient)
                    .shadow(color: AppTheme.primaryColor.opacity(0.5), radius: 10, x: 0, y: 5)
                
                // App Title
                ZStack {
                    Text("PocketPulse")
                        .font(.system(size: AppConstants.Size.balanceFontSize, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.textLight)
                        .padding(AppConstants.Layout.paddingMedium)
                        .background(
                            GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                                Color.clear
                            }
                        )
                }
                // The title moves up with the coins.
                .offset(y: moveCoinUp ? verticalOffset : 0)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                // This block orchestrates the entire animation sequence.
                moveCoinUp = true
                let upTime = (Double(imageCount) * delayBetwnCoins) + 1
                
                // Start the rotation after the coins have moved up.
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime) {
                    isAnimating = true
                }
                
                // Start moving the coins down after the rotation is well underway.
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime * 2 + 0.5) {
                    moveCoinDown = true
                }
                
                // After the entire animation sequence, navigate.
                DispatchQueue.main.asyncAfter(deadline: .now() + upTime * 2 + 3.5) {
                    if isPasscodeEnabled {
                        appDI.navigationCoordinator.showAuth()
                    } else {
                        appDI.navigationCoordinator.showMain()
                    }
                }
            }
        }
    }
}
