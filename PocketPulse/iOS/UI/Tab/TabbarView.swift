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
    
    init(isPlusButtonExpanded: Binding<Bool>) {
        self._isPlusButtonExpanded = isPlusButtonExpanded
        // Hide the native tab bar so our custom one shows alone
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                }
            }
            
            // This ZStack creates the custom tab bar shape and holds the buttons
            ZStack(alignment: .center) {
                RoundedRectangleWithArc(cornerRadius: 28,
                                        isExtendPlus: isPlusButtonExpanded ? 1 : 0)
                    .fill(.ultraThinMaterial)
                    // Deep outer shadow for elevation
                    .shadow(color: Color.black.opacity(0.25), radius: 15, x: 0, y: 10)
                    // Soft ambient shadow
                    .shadow(color: AppTheme.primaryColor.opacity(0.15), radius: 20, x: 0, y: -5)
                    .overlay(
                        RoundedRectangleWithArc(cornerRadius: 28,
                                                isExtendPlus: isPlusButtonExpanded ? 1 : 0)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.8), .white.opacity(0.1)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
                    .overlay(
                        // Inner "shine" gradient to simulate top-down lighting on glass
                        RoundedRectangleWithArc(cornerRadius: 28,
                                                isExtendPlus: isPlusButtonExpanded ? 1 : 0)
                            .stroke(Color.white.opacity(0.3),
                                    lineWidth: 0)
                        // Placeholder for masking if needed, but the stroke above handles edge light.
                            .background(
                                RoundedRectangleWithArc(cornerRadius: 28,
                                                        isExtendPlus: isPlusButtonExpanded ? 1 : 0)
                                    .fill(
                                        LinearGradient(
                                            colors: [.white.opacity(0.2), .clear],
                                            startPoint: .top,
                                            endPoint: .center
                                        )
                                    )
                                    .mask(
                                        RoundedRectangleWithArc(cornerRadius: 28,
                                                                isExtendPlus: isPlusButtonExpanded ? 1 : 0)
                                            .padding(1) // Inset slightly to keep it inside
                                    )
                            )
                    )
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPlusButtonExpanded)

                // Tappable tab items
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
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .contentShape(Rectangle())
            }
            // Add padding to lift the tab bar off the bottom edge. 
            // 34 is roughly the home indicator height on bezel-less iPhones.
            // We add 10 extra points for a "floating" look.
            .padding(.bottom, 34 + 10)
        }
    }
}

#Preview(body: {
    TabV()
})
