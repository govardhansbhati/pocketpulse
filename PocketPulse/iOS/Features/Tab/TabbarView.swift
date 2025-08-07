//
//  TabbarView.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI


struct TabbarView: View {
    @State var selection: AppScreen = .home
    @Binding var isPlusButtonExpanded: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                }
            }
            
            // This ZStack creates the custom tab bar shape and holds the buttons
            ZStack {
                RoundedRectangleWithArc(cornerRadius: 35, isExtendPlus: isPlusButtonExpanded ? 1 : 0)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(height: 80)
                    .padding(.horizontal, 20)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPlusButtonExpanded)

                // This HStack contains the tappable tab items
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
    }
}

#Preview(body: {
    TabV()
})
