//
//  PocketPulseApp.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/12/24.
//
import SwiftUI

@main
struct PocketPulseApp: App {
    @State private var navigateToTab: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                if navigateToTab {
                    TabV()
                        .transition(.move(edge: .trailing))
                } else {
                    SplashView(navigateToTab: $navigateToTab)
                        .transition(.move(edge: .leading))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: navigateToTab)
            .modelContainer(for: [
                AccountModel.self,
                CardModel.self,
                TransactionModel.self,
                BorrowLendModel.self,
                BillModel.self
            ])
        }
    }
}
