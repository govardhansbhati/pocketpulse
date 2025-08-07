//
//  TabV.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
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
                    .frame(width: isExpanded ? (size.width / 2) + 65 : 55, height: 55)
                    .shadow(radius: 4)
                
                // The two menu buttons ("Add Expense" and "Add Income")
                HStack(spacing: 60) {
                    Button(action: {
                        onAddExpense()
                        closeMenu()
                    }) {
                        HStack {
                            Text("Expense")
                            Image(systemName: "arrow.down")
                        }
                    }
                    
                    Button(action: {
                        onAddIncome()
                        closeMenu()
                    }) {
                        HStack {
                            Image(systemName: "arrow.up")
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
                Image(systemName: "plus")
                    .font(.title.weight(.semibold))
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isExpanded.toggle()
                        }
                    }
            }
        
        
    }
    
    private func closeMenu() {
        withAnimation {
            isExpanded = false
        }
    }
}


// MARK: - TabV (Updated to coordinate animations)
struct TabV: View {
    @State private var showingAddExpense = false
    @State private var showingAddIncome = false
    @State private var isPlusButtonExpanded = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // The TabbarView receives the binding to control its background shape
                TabbarView(isPlusButtonExpanded: $isPlusButtonExpanded)
                
                // The ExpandingActionButton is a separate overlay
                ExpandingActionButton(
                    isExpanded: $isPlusButtonExpanded, size: geo.size,
                    onAddExpense: { showingAddExpense = true },
                    onAddIncome: { showingAddIncome = true }
                )
                // Position the button slightly above the tab bar's visual center
                .offset(y: -57.5)
            }
        }
        .sheet(isPresented: $showingAddExpense) { AddExpenseView() }
        .sheet(isPresented: $showingAddIncome) { AddIncomeView() }
    }
}
#Preview {
    TabV()
        .modelContainer(for: [TransactionModel.self, AccountModel.self, CardModel.self], inMemory: true)
}
