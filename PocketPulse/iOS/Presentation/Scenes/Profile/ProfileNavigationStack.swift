//
//  ProfileNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 29/08/25.
//
import SwiftUI
/// The main navigation container for the Side Menu.
/// This stack manages its own navigation path and is presented as an overlay.
/// It also controls the animation for its presentation and dismissal, including a drag gesture.
struct ProfileNavigationStack: View {
    /// A binding to control the visibility of the menu, passed from the parent view.
    @Binding var isShowing: Bool
    
    /// State to track the horizontal drag offset for the swipe gesture.
    @State private var dragOffset: CGFloat = 0
    private let menuWidth: CGFloat = 300

    var body: some View {
        ZStack(alignment: .leading) {
            // The semi-transparent background. Its opacity is animated.
            Color.black
                .opacity(isShowing ? 0.6 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    // Tapping the background dismisses the menu.
                    withAnimation(.easeInOut) {
                        isShowing = false
                    }
                }
            
            // The NavigationStack containing the menu content.
            NavigationStack {
                SideMenuView(isShowing: $isShowing)
            }
            .frame(width: menuWidth)
            // The menu's position is controlled by both the `isShowing` state and the live `dragOffset`.
            .offset(x: isShowing ? 0 : -menuWidth)
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        // Only allow dragging to the left (negative translation).
                        if gesture.translation.width < 0 {
                            dragOffset = gesture.translation.width
                        }
                    }
                    .onEnded { gesture in
                        // If the user swipes more than a third of the menu's width, dismiss it.
                        if gesture.translation.width < -100 {
                            withAnimation(.easeInOut) {
                                isShowing = false
                            }
                        }
                        // On release, snap the menu back to its original position.
                        dragOffset = 0
                    }
            )
        }
        // Animate the main presentation and the final snap-back on gesture end.
        .animation(.easeInOut, value: isShowing)
        .animation(.interactiveSpring(), value: dragOffset)
    }
}
