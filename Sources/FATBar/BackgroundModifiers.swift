import SwiftUI

// MARK: - Version-Aware Background Modifiers

/// ViewModifier that applies version-appropriate background to the search bar.
/// - iOS 26+: Uses `.glassEffect()` for Liquid Glass appearance
/// - iOS 15-18: Uses `.ultraThinMaterial` for blur effect fallback
///
/// This modifier enables backward compatibility by detecting the iOS version at runtime
/// and applying the appropriate visual effect. The version check ensures that Liquid Glass
/// APIs are only called on iOS 26+, while older versions receive a polished fallback.
struct SearchBarBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        // Runtime version detection to select appropriate background effect
        if #available(iOS 26, macOS 26, tvOS 26, watchOS 26, *) {
            // iOS 26+ CODE: Liquid Glass effect for dynamic material with depth
            content.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            // iOS 15-18 FALLBACK: Ultra-thin material provides similar blur effect
            // Uses standard SwiftUI material system available since iOS 15
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

/// ViewModifier that applies version-appropriate background to the main container.
/// - iOS 26+: Uses `.glassEffect()` for Liquid Glass appearance with proper layering
/// - iOS 15-18: Uses `.ultraThinMaterial` with shadow for depth
///
/// This modifier provides the main visual container for the FATBar component. On iOS 26+,
/// it uses Liquid Glass for a premium appearance. On iOS 15-18, it uses ultraThinMaterial
/// with a shadow to approximate the depth and visual quality of Liquid Glass.
struct MainContainerBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        // Runtime version detection to select appropriate container background
        if #available(iOS 26, macOS 26, tvOS 26, watchOS 26, *) {
            // iOS 26+ CODE: Liquid Glass effect with proper layering
            // Uses compositingGroup() to ensure glass effect renders correctly with content
            content
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.clear)
                        .glassEffect(.regular, in: .rect(cornerRadius: 24))
                }
                .compositingGroup()  // Ensure proper layering of glass effect
        } else {
            // iOS 15-18 FALLBACK: Ultra-thin material with shadow for depth
            // Shadow compensates for lack of Liquid Glass depth effects
            content
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
                )
        }
    }
}
