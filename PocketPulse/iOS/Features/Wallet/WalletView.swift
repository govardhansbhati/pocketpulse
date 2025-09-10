//
//  Wallet.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//
import SwiftUI
import SwiftData

enum WalletTab: String, CaseIterable, Identifiable {
    case cards = "Cards"
    case accounts = "Accounts"
    
    var id: String { self.rawValue }
}

// MARK: - Main Wallet View
/// The main view for the Wallet tab, displaying lists of cards and accounts.
struct WalletView: View {
    // MARK: - Properties
    
    /// The SwiftData model context, used for deleting items.
    @Environment(\.modelContext) private var context
    /// An action to navigate to a detail view, injected from the parent navigation stack.
    @Environment(\.navigateWallet) private var navigate
    /// An action to present a sheet for adding or editing an item.
    @Environment(\.presentWalletSheet) private var presentSheet
    
    /// State to control the selected tab (Cards or Accounts).
    @State private var selectedTab: WalletTab = .accounts
    /// State to hold information for an alert, used when a deletion fails.
    @State private var deleteErrorAlert: AlertInfo?
    
    // --- SwiftData Queries ---
    /// Fetches and observes all `AccountModel` objects, sorted by orderIndex.
    @Query(sort: \AccountModel.orderIndex) private var accounts: [AccountModel]
    /// Fetches and observes all `CardModel` objects.
    @Query(sort: \CardModel.orderIndex) private var cards: [CardModel]
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom large title
            HStack {
                Text("Wallet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            // Segmented picker to switch between Cards and Accounts
            Picker("Choose a tab", selection: $selectedTab) {
                ForEach(WalletTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Conditionally display the correct list based on the selected tab.
            if selectedTab == .cards {
                cardListView
            } else {
                accountListView
            }
        }
        // An alert that is shown when `deleteErrorAlert` is not nil.
        .alert(item: $deleteErrorAlert) { alertInfo in
            Alert(title: Text(alertInfo.title), message: Text(alertInfo.message), dismissButton: alertInfo.primaryButton)
        }
    }
    
    // MARK: - Subviews with Swipe Actions
    
    /// A view builder that creates the list of cards.
    @ViewBuilder
    private var cardListView: some View {
        VStack {
            HStack {
                Text("Your Cards")
                    .font(.headline)
                Spacer()
                Button(action: { presentSheet?(.addCard(nil)) }) { // Pass nil to indicate adding a new card
                    Label("Add Card", systemImage: "plus")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if cards.isEmpty {
                Spacer()
                PlaceholderView(
                    imageName: "creditcard.fill",
                    title: "No Cards Added",
                    subtitle: "Add your credit and debit cards to see them here.",
                    buttonLabel: "Add Your First Card"
                ) {
                    presentSheet?(.addCard(nil))
                }
                .padding(.horizontal)
                Spacer()
            } else {
                List {
                    ForEach(cards) { card in
                        Button(action: { navigate?(.cardDetail(card)) }) {
                            CardView(card: card)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteItem(card)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onMove(perform: moveCard)
                }
                .listStyle(.plain)
            }
        }
    }
    
    /// A view builder that creates the list of accounts.
    @ViewBuilder
    private var accountListView: some View {
        VStack {
            HStack {
                Text("Your Accounts")
                    .font(.headline)
                Spacer()
                Button(action: { presentSheet?(.addAccount(nil)) }) { // Pass nil to indicate adding a new account
                    Label("Add Account", systemImage: "plus")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if accounts.isEmpty {
                Spacer()
                PlaceholderView(
                    imageName: "building.columns.fill",
                    title: "No Accounts Added",
                    subtitle: "Add your bank accounts and cash wallets to get started.",
                    buttonLabel: "Add Your First Account"
                ) {
                    presentSheet?(.addAccount(nil))
                }
                .padding(.horizontal)
                Spacer()
            } else {
                List {
                    ForEach(accounts) { account in
                        Button(action: { navigate?(.accountDetail(account)) }) {
                            AccountRowView(account: account)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteAccount(account)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onMove(perform: moveAccount)
                }
                .listStyle(.plain)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Prevents the deletion of a bank account if it has linked debit cards.
    private func deleteAccount(_ account: AccountModel) {
        if account.linkedCards.isEmpty {
            context.delete(account)
        } else {
            // If cards are linked, prepare and show an error alert.
            deleteErrorAlert = AlertInfo(
                title: "Deletion Failed",
                message: "This account cannot be deleted because it has debit cards linked to it. Please delete or re-assign the cards first."
            )
        }
    }
    
    /// A generic function to delete any SwiftData model from the context.
    private func deleteItem<T: PersistentModel>(_ item: T) {
        context.delete(item)
    }
    
    // MARK: - Reordering Logic
    
    /// Reorders the cards in the database after a drag-and-drop action.
    private func moveCard(from source: IndexSet, to destination: Int) {
        var reorderedCards = cards
        reorderedCards.move(fromOffsets: source, toOffset: destination)
        
        // Iterate through the reordered array and update the index of each card.
        for (index, card) in reorderedCards.enumerated() {
            card.orderIndex = index
        }
    }
    
    /// Reorders the accounts in the database after a drag-and-drop action.
    private func moveAccount(from source: IndexSet, to destination: Int) {
        var reorderedAccounts = accounts
        reorderedAccounts.move(fromOffsets: source, toOffset: destination)
        
        for (index, account) in reorderedAccounts.enumerated() {
            account.orderIndex = index
        }
    }
}

#Preview {
    WalletView()
        .modelContainer(for: [AccountModel.self, CardModel.self])
}
