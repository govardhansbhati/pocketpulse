import SwiftUI

/// Provides shared font styles using the Inter font.
/// Make sure the Inter font is included in your bundle and registered in Info.plist.
public enum AppFont {
    
    /// Returns the Inter font with a specified size and weight.
    /// - Parameters:
    ///   - size: The font size.
    ///   - weight: The font weight. Defaults to `.regular`.
    /// - Returns: A `Font` instance using Inter at the specified size and weight.
    public static func inter(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom("Inter", size: size).weight(weight)
    }
    
    /// Inter font at size 12.
    public static let small = inter(12)
    
    /// Inter font at size 16.
    public static let body = inter(16)
    
    /// Inter font at size 22.
    public static let title = inter(22)
    
    /// Inter font at size 34.
    public static let largeTitle = inter(34)
}
