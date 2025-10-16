import SwiftUI

/// Action button component that works identically on iOS 15+ through iOS 26+.
/// Uses standard SwiftUI components that are available across all supported iOS versions.
/// Button interactions and animations work consistently on all platforms.
struct FATActionButtonView: View {
    let button: FATActionButton
    private let buttonSize: CGFloat = 44
    private let wideButtonWidth: CGFloat = 88
    
    var body: some View {
        Button(action: button.action) {
            HStack(spacing: 6) {
                Image(systemName: button.icon)
                    .font(.system(size: 18, weight: .medium))
                
                if button.isWide, let title = button.title {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .lineLimit(1)
                }
            }
            .foregroundColor(.primary)
            .frame(
                width: button.isWide ? wideButtonWidth : buttonSize,
                height: buttonSize
            )
            .contentShape(Rectangle())  // Ensure entire frame is tappable
        }
        .buttonStyle(ScaledButtonStyle())
        .allowsHitTesting(true)  // Explicitly enable hit testing
    }
}
