//
//  Statics.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI

struct StaticsView: View {
    
    @EnvironmentObject var colorManager: BackgroundColorManager
    let targetColors: [Color] = [Color.green.opacity(0.6), .mint.opacity(0.4)]
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()// Background for the whole view
        }
        .onAppear {
            colorManager.update(with: targetColors)
        }
    }
}

#Preview(body: {
    StaticsView()
})
