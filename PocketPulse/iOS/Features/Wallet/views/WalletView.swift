//
//  Wallet.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//
import SwiftUI

struct WalletView: View {
    @State private var selectedTab: WalletTab = .cards
    
    @State private var cardViewModel: CardViewModel = .init()
    
    @State private var accounts: [BankAccount] = [
        BankAccount(accountName: "Salary Account", accountType: "Savings", amount: 58000, details: "SBI - Main Branch"),
        BankAccount(accountName: "Joint Account", accountType: "Current", amount: 33000, details: "HDFC - Family")
    ]
    
    @State private var showAddCard = false
    @State private var showAddAccount = false

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Segmented Picker
                Picker("Select Tab", selection: $selectedTab) {
                    ForEach(WalletTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Divider()
                
                if selectedTab == .cards {
                    HStack {
                        Text("Your Cards")
                            .font(.headline)
                        Spacer()
                        Button(action: { showAddCard = true }) {
                            Image(systemName: "plus.circle")
                            Text("Add Card")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        ForEach(Array(zip(cardViewModel.cards.indices, cardViewModel.cards)), id: \.1.id) { ix, card in
                            CardView(card: card)
                            
                            // first we'll use the offset modifier to stack the cards
                            //                            .offset(y: stackCards && ix != 0 ? -((width / ratioConstant) - 16) * CGFloat(ix) : 0)
                            
                            // next we'll use another modifier to apply the yOffset to the current dragging card
                            //                            .offset(y: ix == activeCardIndex ? yOffSet : 0)
                            
                            // we'll use a ZIndex to prioritise the visibility of the last card
                                .zIndex(10.0 + Double(ix))
                            //                            .gesture(getDragGesture(ix))
                        }
                    }
                    
                } else {
                    HStack {
                        Text("Bank Accounts")
                            .font(.headline)
                        Spacer()
                        Button(action: { showAddAccount = true }) {
                            Image(systemName: "plus.circle")
                            Text("Add Account")
                        }
                    }
                    
                    List {
                        ForEach(accounts) { account in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(account.accountName)
                                    .font(.headline)
                                HStack {
                                    Text("Type: \(account.accountType)")
                                    Spacer()
                                    Text("₹\(Int(account.amount))")
                                        .bold()
                                }
                                Text(account.details)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 6)
                            .onTapGesture {
                                // Edit account logic
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .sheet(isPresented: $showAddCard) {
                AddCardSheet { newCard in
                    //                cards.append(newCard)
                }
            }
            .sheet(isPresented: $showAddAccount) {
                AddAccountSheet { newAccount in
                    accounts.append(newAccount)
                }
            }
        }
    }
}


#Preview {
    WalletView()
}
