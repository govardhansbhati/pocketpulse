//
//  Wallet.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//
import SwiftUI
import SwiftData

struct WalletView: View {
    @State private var selectedTab: WalletTab = .accounts // Default to accounts to see changes
    @State private var showAddCard = false
    @State private var showAddAccount = false

    // Queries to fetch your data from SwiftData
    @Query(sort: \AccountModel.name) private var accounts: [AccountModel]
    @Query private var cards: [CardModel]

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Choose a tab", selection: $selectedTab) {
                    ForEach(WalletTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if selectedTab == .cards {
                            // --- CARD SECTION ---
                            SectionHeaderView(title: "Your Cards", buttonTitle: "Add Card") {
                                showAddCard = true
                            }

                            if cards.isEmpty {
                                ContentUnavailableView("No Cards", systemImage: "creditcard.trianglebadge.exclamationmark", description: Text("You haven't added any cards yet. Tap the button to add your first one."))
                                    .padding(.top, 50)
                            } else {
                                ForEach(cards) { card in
                                    CardView(card: card) // Assumes CardView is defined elsewhere
                                }
                            }
                        } else {
                            // --- ACCOUNT SECTION ---
                            SectionHeaderView(title: "Bank Accounts", buttonTitle: "Add Account") {
                                showAddAccount = true
                            }

                            if accounts.isEmpty {
                                ContentUnavailableView("No Accounts", systemImage: "building.columns.slash", description: Text("You haven't added any accounts yet. Tap the button to add your first one."))
                                     .padding(.top, 50)
                            } else {
                                ForEach(accounts) { account in
                                    AccountRowView(account: account)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Wallet")
            .sheet(isPresented: $showAddCard) {
                 AddCardSheet(onSave: {})
            }
            .sheet(isPresented: $showAddAccount) {
                AddAccountSheet(onSave: {})
            }
        }
    }
}


#Preview {
    WalletView()
        .modelContainer(for: [AccountModel.self, CardModel.self])
}
