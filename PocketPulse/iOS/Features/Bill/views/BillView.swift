//
//  Bill.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI

struct BillView: View {
    
    @EnvironmentObject var colorManager: BackgroundColorManager
    let targetColors: [Color] = [Color.red.opacity(0.5), .pink.opacity(0.3)]
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            Text("Bill")
        }
        .onAppear {
            colorManager.update(with: targetColors)
        }
    }
}
