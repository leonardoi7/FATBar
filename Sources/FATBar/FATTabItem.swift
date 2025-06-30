import SwiftUI

/// Represents a tab item in the floating action tab bar.
public struct FATTabItem: Identifiable {
    public let id = UUID()
    public let icon: String
    public let title: String
    public let view: AnyView
    
    /// Creates a new tab item.
    /// - Parameters:
    ///   - icon: SF Symbol name for the tab icon
    ///   - title: Title of the tab
    ///   - view: The view to display when this tab is selected
    public init<V: View>(icon: String, title: String, view: V) {
        self.icon = icon
        self.title = title
        self.view = AnyView(view)
    }
}
