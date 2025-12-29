import SwiftUI

/// Represents a tab item in the floating action tab bar.
public struct FATTabItem: Identifiable {
    public let id = UUID()
    public let icon: String
    public let title: String
    public let view: AnyView
    public let showLabel: Bool

    /// Creates a new tab item.
    /// - Parameters:
    ///   - icon: SF Symbol name for the tab icon
    ///   - title: Title of the tab
    ///   - view: The view to display when this tab is selected
    ///   - showLabel: Whether to show the label below the icon (default: false)
    public init<V: View>(icon: String, title: String, view: V, showLabel: Bool = false) {
        self.icon = icon
        self.title = title
        self.view = AnyView(view)
        self.showLabel = showLabel
    }
}
