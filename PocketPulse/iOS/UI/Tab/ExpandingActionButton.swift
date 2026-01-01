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
    
    var body: some View {
        
        ZStack {
            // Main button background that expands
            RoundedRectangle(cornerRadius: 27.5) // Constant corner radius for smooth animation
                .fill(Color.white)
                .frame(width: isExpanded ? min((size.width - 40), (size.width / 2) + 65) : 55, height: 55)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isExpanded)
            
            // The two menu buttons ("Add Expense" and "Add Income")
            HStack(spacing: 60) {
                Button(action: {
                    onAddExpense()
                    closeMenu()
                }) {
                    HStack {
                        Text("Expense")
                        Image(systemName: AppAssets.Icons.arrowDown)
                    }
                }
                
                Button(action: {
                    onAddIncome()
                    closeMenu()
                }) {
                    HStack {
                        Image(systemName: AppAssets.Icons.arrowUp)
                        Text("Income")
                    }
                }
            }
            .font(.caption.bold())
            .foregroundColor(.blue)
            .opacity(isExpanded ? 1 : 0)
            .scaleEffect(isExpanded ? 1 : 0.5)
            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: isExpanded)
            
            // The plus icon that transforms into a close icon (X)
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: AppAssets.Icons.plus)
                    .font(.title.weight(.semibold))
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isExpanded)
            }
            .buttonStyle(.plain)
        }
        
        
    }
    
    private func closeMenu() {
        withAnimation {
            isExpanded = false
        }
    }
}
