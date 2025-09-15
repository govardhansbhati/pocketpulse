//
//  PlaceholderView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 02/08/25.
//

import SwiftUI

// MARK: - Placeholder View 
/// A reusable view for displaying a placeholder message when a list is empty.
/// It can optionally include a button to prompt the user for an action.
struct PlaceholderView: View {
    /// The name of the SF Symbol to display.
    let imageName: String
    /// The main title of the placeholder message.
    let title: String
    /// The descriptive subtitle below the title.
    let subtitle: String
    
    /// An optional label for the button. If `nil`, the button is hidden.
    var buttonLabel: String?
    /// An optional closure to be executed when the button is tapped.
    var buttonAction: (() -> Void)?
    
    /// Creates a placeholder view.
    /// - Parameters:
    ///   - imageName: The name of the SF Symbol to display.
    ///   - title: The main title of the placeholder message.
    ///   - subtitle: The descriptive subtitle below the title.
    ///   - buttonLabel: An optional label for the button.
    ///   - buttonAction: An optional closure to be executed when the button is tapped.
    init(imageName: String, title: String, subtitle: String, buttonLabel: String? = nil, buttonAction: (() -> Void)? = nil) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.buttonLabel = buttonLabel
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // The main icon for the placeholder.
            Image(systemName: imageName)
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            // The title and subtitle text.
            Text(title)
                .font(.headline)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Only display the button if both a label and an action are provided.
            if let label = buttonLabel, let action = buttonAction {
                Button(action: action) {
                    Text(label)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
    }
}
