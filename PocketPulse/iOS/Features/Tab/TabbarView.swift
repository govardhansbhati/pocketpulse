//
//  TabbarView.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI

struct TabbarView: View {
    
    @State var selection: AppScreen = .home
    @StateObject var colorManager = BackgroundColorManager()
    @Binding var plusTapped: Bool
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                }
            }
            .background(Color.clear)
            .tabViewStyle(.automatic)
            
            ZStack {
                
                RoundedRectangleWithArc(cornerRadius: 25, isExtendPlus: plusTapped ? 1 : 0)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(height: 80)
                    .padding(.horizontal, 20)
                    .animation(.easeInOut(duration: 0.3), value: plusTapped)
                
                HStack {
                    ForEach(AppScreen.allCases) { screen in
                        AnimatedTabButton(screen: screen, isSelected: selection == screen) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selection = screen
                            }
                        }
                    }
                }
                .frame(height: 80)
                .padding(.horizontal, 20)
            }
        }
        .environmentObject(colorManager)
    }
}


#Preview(body: {
    TabV()
})
