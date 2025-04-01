//
//  TabbarView.swift
//  PocketPulse
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI

struct TabbarView: View {
    
    @State var selection: AppScreen = .home
    @StateObject var colorManager = BackgroundColorManager()
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                }
            }
            .background(Color.clear)
            .tabViewStyle(.automatic)
            
            ZStack {
                
                RoundedRectangleWithArc(cornerRadius: 25, arcRadius: 30)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(height: 80)
                    .padding(.horizontal, 20)
                
                HStack {
                    ForEach(AppScreen.allCases) { screen in
                        AnimatedTabButton(screen: screen, isSelected: selection == screen) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selection = screen
                            }
                        }
                    }
                }
                .frame(height: 80)
                .padding(.horizontal, 20)
            }
        }
        .environmentObject(colorManager)
    }
}

struct TabV: View {
    //    @State var selection: AppScreen? = .home
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    TabbarView()
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.white)
                            .frame(width: 55, height: 55)
                            .position(x: geo.size.width / 2.0, y: geo.size.height - 80)
                            .shadow(radius: 4)
                        Button {
                            // Add button Action
                        } label: {
                            Image(systemName: "plus")
                        }
                        
                        .position(x: geo.size.width / 2.0, y: geo.size.height - 80)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    print("Left button tapped")
                }) {
                    Image(systemName: "list.bullet")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Right button tapped")
                }) {
                    Text("UUU")
                
                }
            }
        }
    }
}

#Preview(body: {
    TabV()
})
