//
//  Wallet.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//
import SwiftUI
import SwiftData

// MARK: - Main Wallet View
struct WalletView: View {
    @Environment(\.navigateWallet) private var navigate
    @Environment(\.presentWalletSheet) private var presentSheet
    
    @State private var selectedTab: WalletTab = .accounts
    
    @Query(sort: \AccountModel.name) private var accounts: [AccountModel]
    @Query private var cards: [CardModel]

    var body: some View {
        VStack {
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
        .navigationTitle("Wallet")
    }

    // MARK: - Subviews
    @ViewBuilder
    private var cardListView: some View {
        VStack {
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { presentSheet?(.addCard) }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
    }
    
    @ViewBuilder
    private var accountListView: some View {
        VStack {
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { presentSheet?(.addAccount) }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
    }
}


#Preview {
    WalletView()
        .modelContainer(for: [AccountModel.self, CardModel.self])
}
