import SwiftUI

// MARK: - Version-Aware Background Modifiers

/// ViewModifier that applies version-appropriate background to the search bar.
/// - iOS 26+: Uses `.glassEffect()` for Liquid Glass appearance
/// - iOS 15-25: Uses `.ultraThinMaterial` for blur effect fallback
struct SearchBarBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, macOS 26, tvOS 26, watchOS 26, *) {
            // iOS 26+: Liquid Glass effect
            content.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            // iOS 15-25: Fallback with ultraThinMaterial
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

/// ViewModifier that applies version-appropriate background to the main container.
/// - iOS 26+: Uses `.glassEffect()` for Liquid Glass appearance
/// - iOS 15-25: Uses `.ultraThinMaterial` with shadow for depth
struct MainContainerBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, macOS 26, tvOS 26, watchOS 26, *) {
            // iOS 26+: Liquid Glass effect
            content.glassEffect(.regular, in: .rect(cornerRadius: 24))
        } else {
            // iOS 15-25: Fallback with ultraThinMaterial and shadow for depth
            content
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
                )
        }
    }
}
