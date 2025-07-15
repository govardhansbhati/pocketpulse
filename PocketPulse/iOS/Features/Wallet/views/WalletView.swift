//
//  Wallet.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//
import SwiftUI
import SwiftData

struct WalletView: View {
    @State private var selectedTab: WalletTab = .cards
    @State private var showAddCard = false
    @State private var showAddAccount = false

    @Query private var accounts: [AccountModel]
    @Query private var cards: [CardModel]

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Tab", selection: $selectedTab) {
                    ForEach(WalletTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if selectedTab == .cards {
                            HStack {
                                Text("Your Cards")
                                    .font(.headline)
                                Spacer()
                                Button {
                                    showAddCard = true
                                } label: {
                                    Label("Add Card", systemImage: "plus.circle")
                                }
                            }
                            .padding(.horizontal)

                            ForEach(cards) { card in
                                CardView(card: card)
//                                    .padding(.horizontal)
                            }

                        } else {
                            HStack {
                                Text("Bank Accounts")
                                    .font(.headline)
                                Spacer()
                                Button {
                                    showAddAccount = true
                                } label: {
                                    Label("Add Account", systemImage: "plus.circle")
                                }
                            }
                            .padding(.horizontal)

                            ForEach(accounts) { account in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(account.name)
                                        .font(.headline)
                                    HStack {
                                        Text("Type: \(account.type.rawValue.capitalized)")
                                        Spacer()
                                        Text("₹\(Int(account.balance))")
                                            .bold()
                                    }
                                    Text(account.details)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(.blue.opacity(0.05))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Wallet")
            .sheet(isPresented: $showAddCard) {
                AddCardSheet {}
            }
            .sheet(isPresented: $showAddAccount) {
                AddAccountSheet {}
            }
        }
    }
}

#Preview {
    WalletView()
        .modelContainer(for: [AccountModel.self, CardModel.self])
}
