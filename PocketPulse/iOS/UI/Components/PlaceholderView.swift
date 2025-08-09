//
//  PlaceholderView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//

import SwiftUI

// MARK: - Reusable Placeholder View 
struct PlaceholderView: View {
    let imageName: String, title: String, subtitle: String, buttonLabel: String
    let buttonAction: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: imageName).font(.system(size: 50)).foregroundColor(.gray)
            Text(title).font(.headline)
            Text(subtitle).font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
            Button(action: buttonAction) {
                Text(buttonLabel).fontWeight(.semibold).frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(12)
            }
        }
        .padding().background(Color(UIColor.systemGray6)).cornerRadius(16)
    }
}
