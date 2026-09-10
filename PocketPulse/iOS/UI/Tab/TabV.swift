//
//  TabV.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//

import SwiftData
import SwiftUI

// MARK: - TabV (Main App View)
/// The root view that contains the tab bar and the expanding action button.
/// It is now also responsible for managing and presenting the side menu overlay.
struct TabV: View {
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject private var detectionManager = TransactionDetectionManager.shared
    
    @State private var showingAddExpense = false
    @State private var showingAddIncome = false
    @State private var isPlusButtonExpanded = false
    @State private var reviewingTransaction: DetectedTransaction?
    
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

            // MARK: - Detected Transaction Notification Banner
            VStack {
                if let detected = detectionManager.activePromptTransaction {
                    DetectedTransactionBanner(
                        transaction: detected,
                        onQuickAdd: {
                            Task {
                                let factory = TransactionFactory(context: context)
                                try? await factory.makeUseCase().quickAdd(detected: detected)
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    detectionManager.dismissTransaction(detected)
                                }
                            }
                        },
                        onReview: {
                            reviewingTransaction = detected
                            if detected.type == .expense {
                                showingAddExpense = true
                            } else {
                                showingAddIncome = true
                            }
                        },
                        onDismiss: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                detectionManager.dismissTransaction(detected)
                            }
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 54)
                }
                Spacer()
            }
            .animation(.spring(response: 0.45, dampingFraction: 0.8), value: detectionManager.activePromptTransaction)
            .sheet(isPresented: $showingAddExpense, onDismiss: {
                if let reviewing = reviewingTransaction {
                    detectionManager.dismissTransaction(reviewing)
                    reviewingTransaction = nil
                }
            }) {
                TransactionFactory(context: context).makeAddExpenseView(initialData: reviewingTransaction)
            }
            .sheet(isPresented: $showingAddIncome, onDismiss: {
                if let reviewing = reviewingTransaction {
                    detectionManager.dismissTransaction(reviewing)
                    reviewingTransaction = nil
                }
            }) {
                TransactionFactory(context: context).makeAddIncomeView(initialData: reviewingTransaction)
            }
            
            ProfileNavigationStack(isShowing: $isSideMenuShowing)
            
        }
        .onAppear {
            detectionManager.checkForClipboardTransaction()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                detectionManager.checkForClipboardTransaction()
            }
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
