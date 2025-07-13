//
//  TabV.swift
//  PocketPulse
//
//  Created by govardhan singh on 13/07/25.
//


import SwiftUI

struct TabV: View {
    @State private var progress: CGFloat = 0.25
    @State var plusTapped: Bool = false
    @State var showingAddExpense = false
    @State private var showingAddIncome = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    TabbarView( plusTapped: $plusTapped)
                    ZStack {
                        RoundedRectangleShape(cornerRadius: plusTapped ? 15 : geo.size.width / 2)
                            .foregroundStyle(Color.white)
                            .frame(width: plusTapped ? (geo.size.width / 2) + 65 : 55, height: plusTapped ? 65 : 55) // Slightly wider for rectangle effect
                            .position(x: geo.size.width / 2.0, y: geo.size.height - (plusTapped ? 100 : 80))
                            .shadow(radius: 4)
                            .animation(.easeInOut(duration: 0.5), value: plusTapped)
                        Rectangle()
                            .foregroundStyle(Color.blue)
                            .frame(width: 2, height: plusTapped ? 65 : 20)
                            .animation(.easeInOut(duration: 0.5), value: plusTapped)
                            .position(x: geo.size.width / 2.0, y: geo.size.height - (plusTapped ? 100 : 80))
                        Rectangle()
                            .foregroundStyle(Color.blue)
                            .frame(width: plusTapped ? 0 : 20, height: 2)
                            .position(x: geo.size.width / 2.0, y: geo.size.height - (plusTapped ? 100 : 80))
                        
                        RoundedRectangleShape(cornerRadius: 15)
                            .trim(from: 0.25, to: progress) // Trim the stroke
                            .stroke(Color.blue, lineWidth: 1.5)
                            .rotationEffect(.degrees(180))
                            .frame(width:  (geo.size.width / 2) + 65, height: 65)                            .position(x: geo.size.width / 2.0, y: geo.size.height - (100))
                            .animation(.easeInOut(duration: 0.5), value: progress)
                        RoundedRectangleShape(cornerRadius: 15)
                            .trim(from: 0.25, to: progress) // Trim the stroke
                            .stroke(Color.blue, lineWidth: 1.5)
                        //                            .rotationEffect(.degrees(180))
                            .frame(width:  (geo.size.width / 2) + 65, height: 65)                            .position(x: geo.size.width / 2.0, y: geo.size.height - (100))
                            .animation(.easeInOut(duration: 0.5), value: progress)
                        if progress > 0.25 {
                            HStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        // Add button Action
//                                        plusTapped.toggle()
                                        showingAddExpense = true
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
//                                            progress = 0.75
                                        }
                                    } label: {
                                        Text("Add Expense")
                                    }
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Button {
                                        // Add button Action
//                                        plusTapped.toggle()
                                        showingAddIncome = true
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
//                                            progress = 0.75
                                        }
                                    } label: {
                                        Text("Add Income")
                                    }
                                    Spacer()
                                }
                            }
                            
                            .frame(width: (geo.size.width / 2) + 65 , height: 55)
                            .position(x: geo.size.width / 2.0, y: geo.size.height - (100))
                            .opacity(plusTapped ? 1 : 0)
                            .animation(.easeOut(duration: 1.6), value: plusTapped)
                        }
                        
                        
                        Button {
                            // Add button Action
                            plusTapped.toggle()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
                                progress = plusTapped ? 0.75 : 0.25
                            }
                        } label: {
                            Color.clear
                                .frame(width: 80, height: 80)
                        }
                        .position(x: geo.size.width / 2.0, y: geo.size.height - 80)
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView ()
//                    title, amount, date , category in
//                    plusTapped.toggle()
//                    progress =  0.25
            
            }
            .sheet(isPresented: $showingAddIncome) {
                AddIncomeView()
//                    plusTapped.toggle()
//                    progress =  0.25
                
            }
        }
    }
}

#Preview {
    TabV()
        .modelContainer(for: [TransactionModel.self, AccountModel.self], inMemory: true)
}
