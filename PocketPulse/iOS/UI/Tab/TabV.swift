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
    @Environment(\.modelContext) private var context
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
                        isExpanded: $isPlusButtonExpanded,
                        size: geo.size,
                        onAddExpense: { showingAddExpense = true },
                        onAddIncome: { showingAddIncome = true }
                    )
                    // Original offset was -57.5. We shifted the bar up by 44 (34+10).
                    // So we shift the button up by 44 more: -57.5 - 44 = -101.5
                    .offset(y: -101.5)
                }
            }

            .sheet(isPresented: $showingAddExpense) {
                // Ensure modelContext is available or passed. 
                // Since TabV does not explicitly have @Environment(\.modelContext) property, 
                // we should add it. See property addition below.
                // Assuming we add `context` property.
                TransactionFactory(context: context).makeAddExpenseView()
            }
            .sheet(isPresented: $showingAddIncome) {
                TransactionFactory(context: context).makeAddIncomeView()
            }
            
                ProfileNavigationStack(isShowing: $isSideMenuShowing)
            
        }
        // Provide the action to the environment so child views (like HomeView) can trigger the menu.
        .environment(\.presentSideMenu, PresentSideMenuAction {
            withAnimation {
                isSideMenuShowing.toggle()
            }
        })
        // Clips content (like the hidden side menu at negative offset) so it doesn't appear
        // during the TabV's slide-in transition.
        .clipped()
    }
}
// Wrapper views to handle dependency injection using the environment context

#Preview {
    TabV()
        .modelContainer(for: [TransactionModel.self, AccountModel.self, CardModel.self], inMemory: true)
}
