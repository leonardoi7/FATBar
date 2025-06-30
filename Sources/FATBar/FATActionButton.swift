import SwiftUI

/// Represents an action button that can be displayed above the tab bar.
public struct FATActionButton: Identifiable {
    public let id = UUID()
    public let icon: String
    public let title: String?
    public let action: () -> Void
    public let isWide: Bool
    
    /// Creates a new action button.
    /// - Parameters:
    ///   - icon: SF Symbol name for the button icon
    ///   - title: Optional title text (only displayed if isWide is true)
    ///   - isWide: Whether the button should be wider to accommodate title text
    ///   - action: Action to perform when the button is tapped
    public init(icon: String, title: String? = nil, isWide: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.isWide = isWide
        self.action = action
    }
}
