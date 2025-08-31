//
//  TabV.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import SwiftUI

// MARK: - TabV (Main App View)
/// The root view that contains the tab bar and the expanding action button.
/// It is now also responsible for managing and presenting the side menu overlay.
struct TabV: View {
    @State private var showingAddExpense = false
    @State private var showingAddIncome = false
    @State private var isPlusButtonExpanded = false
    
    // State to control the side menu's visibility
    @State private var isSideMenuShowing = false
    
    var body: some View {
        ZStack {
            // The main content of the app (the tab bar and the FAB)
            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    TabbarView(isPlusButtonExpanded: $isPlusButtonExpanded)
                    
                    ExpandingActionButton(
                        isExpanded: $isPlusButtonExpanded, size: geo.size,
                        onAddExpense: { showingAddExpense = true },
                        onAddIncome: { showingAddIncome = true }
                    )
                    .offset(y: -57.5)
                }
            }
            .sheet(isPresented: $showingAddExpense) { AddExpenseView() }
            .sheet(isPresented: $showingAddIncome) { AddIncomeView() }
            
                ProfileNavigationStack(isShowing: $isSideMenuShowing)
            
        }
        // Provide the action to the environment so child views (like HomeView) can trigger the menu.
        .environment(\.presentSideMenu, PresentSideMenuAction {
            withAnimation {
                isSideMenuShowing.toggle()
            }
        })
    }
}

#Preview {
    TabV()
        .modelContainer(for: [TransactionModel.self, AccountModel.self, CardModel.self], inMemory: true)
}
