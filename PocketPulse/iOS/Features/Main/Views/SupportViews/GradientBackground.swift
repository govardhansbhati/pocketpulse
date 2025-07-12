//
//  DiagonalWaveBackgroundView.swift
//  PocketPulse
//
//  Created by govardhan singh on 04/01/25.
//

import SwiftUI

struct GradientBackgroundView: View {
    
    @EnvironmentObject var colorManager: BackgroundColorManager

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colorManager.currentColors), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}


class BackgroundColorManager: ObservableObject {
    @Published var currentColors: [Color] = [.gray, .green] // Initial colors

    func update(with newColors: [Color], animated: Bool = true) {
        if animated {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.currentColors = newColors
                }
            }
        } else {
            currentColors = newColors
        }
    }
}
