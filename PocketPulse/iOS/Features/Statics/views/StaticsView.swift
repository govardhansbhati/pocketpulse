//
//  Statics.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI

struct StaticsView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all) // Background for the whole view
            Ripple3DButton() {
                print("Blue button tapped!")
            }
            .padding()
        }
    }
}

struct Ripple3DButton: View {
    @State private var isPressed = false
    @State private var rippleActive = false
    
    var action: () -> Void
    
    var body: some View {
        ZStack {
            if rippleActive {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .scaleEffect(rippleActive ? 2 : 1)
                    .opacity(rippleActive ? 0 : 1)
                    .animation(.easeOut(duration: 0.5), value: rippleActive)
            }
            
            Button(action: {
                rippleActive = true
                isPressed = true
                action()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isPressed = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    rippleActive = false
                }
            }) {
                Text("Tap Me")
                    .font(.title2)
                    .bold()
                    .frame(width: 120, height: 60)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(color: isPressed ? Color.black.opacity(0.2) : Color.black.opacity(0.5), radius: isPressed ? 2 : 6, x: 0, y: isPressed ? 1 : 5)
                                .scaleEffect(isPressed ? 0.95 : 1)
                                .animation(.easeInOut(duration: 0.2), value: isPressed)
                        }
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}


#Preview(body: {
    StaticsView()
})
