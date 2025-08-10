//
//  TabV.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import SwiftUI

// MARK: - TabV 
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
