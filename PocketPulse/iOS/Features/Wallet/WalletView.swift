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
struct WalletView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.navigateWallet) private var navigate
    @Environment(\.presentWalletSheet) private var presentSheet
    
    @State private var selectedTab: WalletTab = .accounts
    @State private var deleteErrorAlert: AlertInfo? // For the deletion error
    
    @Query(sort: \AccountModel.name) private var accounts: [AccountModel]
    @Query private var cards: [CardModel]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Wallet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            Picker("Choose a tab", selection: $selectedTab) {
                ForEach(WalletTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if selectedTab == .cards {
                cardListView
            } else {
                accountListView
            }
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private var cardListView: some View {
        
        List {
            ForEach(cards) { card in
                // Tapping the row now navigates to the detail view
                Button(action: { navigate?(.cardDetail(card)) }) {
                    CardView(card: card)
                }
                .buttonStyle(.plain) // Use plain style to make the whole row tappable
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteItem(card)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private var accountListView: some View {
        List {
            ForEach(accounts) { account in
                // Tapping the row now navigates to the detail view
                Button(action: { navigate?(.accountDetail(account)) }) {
                    AccountRowView(account: account)
                }
                .buttonStyle(.plain)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteItem(account)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    // Helper function to delete any SwiftData model
    private func deleteItem<T: PersistentModel>(_ item: T) {
        context.delete(item)
    }
    
    private func deleteAccount(_ account: AccountModel) {
        if account.linkedCards.isEmpty {
            context.delete(account)
        } else {
            deleteErrorAlert = AlertInfo(
                title: "Deletion Failed",
                message: "This account cannot be deleted because it has debit cards linked to it. Please delete or re-assign the cards first."
            )
        }
    }
}

#Preview {
    WalletView()
        .modelContainer(for: [AccountModel.self, CardModel.self])
}
