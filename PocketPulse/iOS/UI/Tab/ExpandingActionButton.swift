//
//  ExpandingActionButton.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 08/08/25.
//

import SwiftUI

struct ExpandingActionButton: View {
    @Binding var isExpanded: Bool
    var size: CGSize
    // Closures for the button actions
    var onAddExpense: () -> Void
    var onAddIncome: () -> Void
    var onAddTransfer: () -> Void
    
    var body: some View {
        ZStack {
            // Floating "Transfer" Button above the main pill
            if isExpanded {
                Button(action: {
                    onAddTransfer()
                    closeMenu()
                }, label: {
                    HStack(spacing: 6) {
                        Image(systemName: AppAssets.Icons.arrowLeftArrowRight)
                            .font(.system(size: 13, weight: .bold))
                        Text("Transfer")
                            .font(.caption.bold())
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color(hex: "03A9F4").opacity(0.8), Color.white.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(color: Color(hex: "03A9F4").opacity(0.4), radius: 10, x: 0, y: 4)
                    )
                })
                .buttonStyle(.plain)
                .offset(y: -58)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.6).combined(with: .offset(y: 20)).combined(with: .opacity),
                    removal: .scale(scale: 0.6).combined(with: .opacity)
                ))
            }
            
            // Main button background that expands
            RoundedRectangle(cornerRadius: 27.5) // Constant corner radius for smooth animation
                .fill(AppTheme.primaryGradient)
                .frame(width: isExpanded ? min((size.width - 40), (size.width / 2) + 65) : 55, height: 55)
                // Outer glowing shadow
                .shadow(color: AppTheme.primaryColor.opacity(0.5), radius: 12, x: 0, y: 8)
                // Bevel/Inner Highlight Overlay
                .overlay(
                    RoundedRectangle(cornerRadius: 27.5)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isExpanded)
            
            // The two menu buttons ("Add Expense" and "Add Income")
            HStack(spacing: 60) {
                Button(action: {
                    onAddExpense()
                    closeMenu()
                }, label: {
                    HStack {
                        Text("Expense")
                        Image(systemName: AppAssets.Icons.arrowDown)
                    }
                })
                
                Button(action: {
                    onAddIncome()
                    closeMenu()
                }, label: {
                    HStack {
                        Image(systemName: AppAssets.Icons.arrowUp)
                        Text("Income")
                    }
                })
            }
            .font(.caption.bold())
            .foregroundColor(.white)
            .opacity(isExpanded ? 1 : 0)
            .scaleEffect(isExpanded ? 1 : 0.5)
            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: isExpanded)
            
            // The plus icon that transforms into a close icon (X)
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }, label: {
                Image(systemName: AppAssets.Icons.plus)
                    .font(.title.weight(.semibold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isExpanded)
            })
            .buttonStyle(.plain)
        }
    }
    
    private func closeMenu() {
        withAnimation {
            isExpanded = false
        }
    }
}
