//
//  Wallet.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI

struct WalletView: View {
    
    @EnvironmentObject var colorManager: BackgroundColorManager
        let targetColors: [Color] = [Color.orange.opacity(0.8), .yellow.opacity(0.6)]
    var body: some View {
        ZStack {
            GradientBackgroundView()
            Text("Wallet")
        }
        .onAppear {
            colorManager.update(with: targetColors)
        }
    }
    
}
