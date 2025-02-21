//
//  Home.swift
//  PocketPulse
//
//  Created by govardhan singh on 31/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.navigate) private var navigate
    
    // TODO: update after implementing SwiftDATA
    var userName: String = "John Doe"
    var currentBalance: Double = 12_345.67
    var income: Double = 5_000.00
    var expenses: Double = 3_200.00
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                DiagonalWaveBackgroundView()
                
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
                    HStack (spacing: 20){
                        // Current Balance - Neumorphic Design
                        
                        VStack {
                            Text("Current Balance")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("$\(String(format: "%.2f", currentBalance))")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height /  5)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(UIColor.systemGray6))
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        )
                        
                        // Income & Expenses Section
                        VStack(spacing: 20) {
                            // Income View
                            VStack {
                                Text("Income")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text("$\(String(format: "%.2f", income))")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(UIColor.systemGray6))
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -3, y: -3)
                            )
                            
                            // Expenses View
                            VStack {
                                Text("Expenses")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text("$\(String(format: "%.2f", expenses))")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.red)
                            }
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(UIColor.systemGray6))
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -3, y: -3)
                            )
                        }
                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height /  5)
                    }
                    .frame(maxHeight: geometry.size.height /  5)
                    .padding()
                    CardCarouselView()
                        .frame(maxHeight: geometry.size.height /  4)
                    Spacer()
                        .frame(maxHeight: .infinity)
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
}
