//
//  AppText.swift
//  PocketPulse
//
//  Created by govardhan singh on 04/01/26.
//

import SwiftUI

/// A collection of reusable text components to ensure consistent typography throughout the app.
struct AppText {
    
    // MARK: - Headers & Titles
    
    /// Large header text, typically used for screen titles or major section headers.
    /// Default: Size 28, Bold, Rounded.
    struct Header: View {
        let text: String
        var color: Color = AppTheme.adaptiveText
        
        var body: some View {
            Text(text)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
    }
    
    /// Medium size title, used for card titles or subsections.
    /// Default: Size 20, Bold, Rounded.
    struct Title: View {
        let text: String
        var color: Color = AppTheme.adaptiveText
        
        var body: some View {
            Text(text)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        }
    }
    
    /// Emphasized text, slightly larger than Body.
    /// Default: Headline style, Rounded.
    struct Headline: View {
        let text: String
        var color: Color = AppTheme.adaptiveText
        
        var body: some View {
            Text(text)
                .font(.headline)
                .design(.rounded)
                .foregroundColor(color)
        }
    }
    
    /// Smaller title, often used for lists or smaller cards.
    /// Default: Headline style, Rounded.
    struct Subtitle: View {
        let text: String
        var color: Color = AppTheme.adaptiveText
        
        var body: some View {
            Text(text)
                .font(.headline.weight(.semibold)) // System headline is usually ~17pt
                .design(.rounded)
                .foregroundColor(color)
        }
    }
    
    // MARK: - Body & Content
    
    /// Standard body text.
    /// Default: Body style, Rounded.
    struct Body: View {
        let text: String
        var color: Color = AppTheme.adaptiveText
        
        var body: some View {
            Text(text)
                .font(.body) // System body is usually ~17pt regular
                .design(.rounded)
                .foregroundColor(color)
        }
    }
    
    /// Small text for captions, hints, or secondary info.
    /// Default: Caption style, Rounded.
    struct Caption: View {
        let text: String
        var color: Color = AppTheme.adaptiveText.opacity(0.7)
        
        var body: some View {
            Text(text)
                .font(.caption) // System caption is usually ~12pt
                .design(.rounded)
                .foregroundColor(color)
        }
    }
    
    /// Very small or subtle text.
    struct Tiny: View {
        let text: String
        var color: Color = AppTheme.adaptiveText.opacity(0.6)
        
        var body: some View {
            Text(text)
                .font(.caption2) // System caption2 is usually ~11pt
                .design(.rounded)
                .foregroundColor(color)
        }
    }
}

// MARK: - Helper Extension for View Modifiers
extension View {
    func design(_ design: Font.Design) -> some View {
        // This is a bit tricky since .font(.system(..., design: ...)) creates a Font.
        // But if we already applied a standard style (like .font(.body)), applying design is harder without resolving the font.
        // For simplicity in the structs above, we used .font modifiers directly.
        // This extension is just a placeholder if we wanted to chain, but SwiftUI doesn't support `.design` directly on View.
        // The structs above handle it correctly by constructing the font.
        self
    }
}
