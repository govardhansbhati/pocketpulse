//
//  HomeNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh on 04/01/25.
//
import SwiftUI
import SwiftData

// MARK: - Home Navigation Stack
struct HomeNavigationStack: View {
    @Environment(\.modelContext) private var context
    @State private var path = NavigationPath()
    @State private var presentingSheet: HomeRoute.Sheet?

    var body: some View {
        NavigationStack(path: $path) {
            HomeFactory(context: context).makeHomeView() // injected HomeView
                .navigationDestination(for: HomeRoute.self) { route in
                    route.destination(context: context)
                }
        }
        .sheet(item: $presentingSheet) { sheet in
            switch sheet {
            case .addCard(let card):
                WalletFactory(context: context).makeAddCardSheet(cardToEdit: card, onSave: {})
            case .balanceBreakdown:
                 HomeFactory(context: context).makeBreakdownView()
                    .presentationDetents([.medium, .large])
            case .addExpense:
                TransactionFactory(context: context).makeAddExpenseView()
            case .addIncome:
                TransactionFactory(context: context).makeAddIncomeView()
            }
        }
        .environment(\.navigateHome, NavigateAction { route in path.append(route) })
        .environment(\.presentSheet, PresentSheetAction { sheet in presentingSheet = sheet })
    }
}
// Environment Keys
private struct NavigateHomeKey: EnvironmentKey {
    static let defaultValue: NavigateAction<HomeRoute>? = nil
}
private struct PresentSheetKey: EnvironmentKey {
    static let defaultValue: PresentSheetAction<HomeRoute.Sheet>? = nil
}


// MARK: - Home Navigation Routes
enum HomeRoute: Hashable {
    // Cases for pushing views onto the stack
    case transactionList
    case allCards
    case notification

    // The destination builder for pushed views
    @MainActor @ViewBuilder
    func destination(context: ModelContext) -> some View {
        switch self {
        case .transactionList:
            TransactionFactory(context: context).makeTransactionListView()
        case .allCards:
            WalletFactory(context: context).makeWalletView() // Reuse WalletView as All Cards
        case .notification:
            NotificationFactory(context: context).makeNotificationView()
        }
    }
    
    // The Sheet enum now includes the balance breakdown case
    enum Sheet: Identifiable {
        case addCard(CardModel?)
        case balanceBreakdown
        case addExpense
        case addIncome
        
        var id: String {
            switch self {
            case .addCard: return "addOrEditCard"
            case .balanceBreakdown: return "balanceBreakdown"
            case .addExpense: return "addExpense"
            case .addIncome: return "addIncome"
            }
        }
    }
}
