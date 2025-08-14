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
    @Environment(\.navigateWallet) private var navigate
    @Environment(\.presentWalletSheet) private var presentSheet
    
    @State private var selectedTab: WalletTab = .accounts
    
    @Query(sort: \AccountModel.name) private var accounts: [AccountModel]
    @Query private var cards: [CardModel]
    
    var body: some View {
        VStack {
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
        VStack {
            HStack {
                Text("Your Cards")
                    .font(.headline)
                Spacer()
                Button(action: { presentSheet?(.addCard) }) {
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
                    presentSheet?(.addCard)
                }
                .padding(.horizontal)
                Spacer()
            } else {
                List {
                    ForEach(cards) { card in
                        CardView(card: card)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private var accountListView: some View {
        VStack {
            HStack {
                Text("Your Accounts")
                    .font(.headline)
                Spacer()
                Button(action: { presentSheet?(.addAccount) }) {
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
                    presentSheet?(.addAccount)
                }
                .padding(.horizontal)
                Spacer()
            } else {
                List {
                    ForEach(accounts) { account in
                        AccountRowView(account: account)
                            .onTapGesture {
                                navigate?(.accountDetail(id: account.id))
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    WalletView()
        .modelContainer(for: [AccountModel.self, CardModel.self])
}
