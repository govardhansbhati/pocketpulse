//
//  Home.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.navigateHome) private var navigate
    
    // TODO: update after implementing SwiftDATA
    var userName: String = "John Doe"
    var currentBalance: Double = 12_345.67
    var income: Double = 5_000.00
    var expenses: Double = 3_200.00
    
    let targetColors: [Color] = [Color.blue.opacity(0.7), Color.purple.opacity(0.5)]
    
    let transactions: [Transaction] = [
            Transaction(title: "Groceries", amount: 1200, date: Date(), isExpense: true),
            Transaction(title: "Salary", amount: 50000, date: Date(), isExpense: false),
            Transaction(title: "Electricity Bill", amount: 1800, date: Date(), isExpense: true)
        ]
    
    
    var body: some View {
        GeometryReader { geometry in
            
            let height = geometry.size.height / 5
            
            ZStack {
                // Background
                
                // Gradient background
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.blue, Color.purple]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                    .ignoresSafeArea()

                    // Glass background layer
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Top Bar
                        HStack {
                            // Profile Button
                            Button(action: {
                                print("Profile button tapped")
                            }) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.primary)
                            }
                            
                            // User Name
                            Text(userName)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.primary)
                                .padding(.leading, 8)
                            
                            Spacer()
                            
                            // Notification Button
                            Button(action: {
                                print("Notification button tapped")
                            }) {
                                Image(systemName: "bell.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.primary)
                            }
                        }
                        //                .frame(height: 40)
                        .padding(.horizontal)
                        HStack(spacing: 10) {
                                // Current Balance view
                            VStack (alignment: .center, spacing: 10){
                                    Text("Current Balance")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Text("$\(String(format: "%.2f", currentBalance))")
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(.primary)
                                        .lineLimit(1)             // <- prevent multiline
                                            .minimumScaleFactor(0.5)

                                }
                            .padding(.vertical)
                            .padding(.horizontal, 5)
                                .frame(maxWidth: .infinity)
                                .frame(height: height)
                                .glassStyle(cornerRadius: 20)

                                // Income & Expenses Section
                                VStack(spacing: 10) {
                                    VStack {
                                        Text("Income")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                        Text("$\(String(format: "%.2f", income))")
                                            .font(.title3)
                                            .bold()
                                            .foregroundColor(.green)
                                        
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: ((height / 2) - 20))
                                    .glassStyle()
//
                                    VStack {
                                        Text("Expenses")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                        Text("$\(String(format: "%.2f", expenses))")
                                            .font(.title3)
                                            .bold()
                                            .foregroundColor(.red)

//                                        Spacer()
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: ((height / 2) - 20))
                                    .glassStyle()
                                }
                                
                                .frame(maxWidth: .infinity)
                                .frame(height: height - 20)
//                                .glassStyle()
                            }
                            .frame(height: height)
                        .padding()
//                        CardCarouselView()
                        VStack (alignment: .leading, spacing: 12){
                            
                            HStack {
                                Text("Recent Transactions").tracking(1.1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .overlay(alignment:.trailing) {
                                        Button {
                                            
                                            
                                        } label: {
                                            Image(systemName: "arrow.up.arrow.down")
                                        }
                                        
                                        .buttonStyle(.plain)
                                    }
                            }
                            
                            ForEach(transactions.prefix(3)) { transaction in
                                            TransactionRow(transaction: transaction)
                                        }
                            
                        }
                        .offset(y: -400)
                        .padding()
                        Spacer()
                            .frame(maxHeight: .infinity)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

