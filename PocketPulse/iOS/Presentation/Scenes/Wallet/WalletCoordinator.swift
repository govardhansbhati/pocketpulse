//
//  WalletNavigationStack.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//

import SwiftUI

// MARK: - Wallet Navigation Stack
struct WalletNavigationStack: View {
    @Environment(\.modelContext) private var context
    @State private var path = NavigationPath()
    @State private var presentingSheet: WalletRoute.Sheet?

    var body: some View {
        NavigationStack(path: $path) {
            WalletFactory(context: context).makeWalletView() // WalletView is the root of this stack
                .navigationDestination(for: WalletRoute.self) { route in
                    route.destination
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $presentingSheet) { sheet in
            switch sheet {
            case .addCard(let card):
                let service = CardsService(context: context)
                let useCase = CardUseCase(service: service)
                let viewModel = AddCardViewModel(useCase: useCase)
                AddCardSheet(viewModel: viewModel, cardToEdit: card, onSave: {})
            case .addAccount(let account):
                let service = AccountsService(context: context)
                let useCase = AccountUseCase(service: service)
                let viewModel = AddAccountViewModel(useCase: useCase)
                AddAccountSheet(viewModel: viewModel, accountToEdit: account, onSave: {})
            }
        }
        .environment(\.navigateWallet, NavigateAction { route in
            path.append(route)
        })
        .environment(\.presentWalletSheet, PresentSheetAction { sheet in
             presentingSheet = sheet
        })
    }
}


// MARK: - Wallet Navigation Routes
enum WalletRoute: Hashable {
    // Cases for pushing views onto the stack
    case accountDetail(AccountModel) // Pass the whole model for easier access
    case cardDetail(CardModel)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .accountDetail(let account):
            AccountDetailView(account: account)
        case .cardDetail(let card):
            CardDetailView(card: card)
        }
    }
    
    // Defines sheets that can be presented from the Wallet screen
    // The associated value holds the item to be edited (or nil if adding a new one)
    enum Sheet: Identifiable {
        case addCard(CardModel?)
        case addAccount(AccountModel?)
        
        var id: String {
            switch self {
            case .addCard: return "addOrEditCard"
            case .addAccount: return "addOrEditAccount"
            }
        }
    }
}
