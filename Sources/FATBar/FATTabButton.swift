import SwiftUI

struct FATTabButton: View {
    let tab: FATTabItem
    let isSelected: Bool
    let action: () -> Void
    private let buttonSize: CGFloat = 44
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                    .symbolVariant(isSelected ? .fill : .none)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                if isSelected {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 5, height: 5)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .foregroundColor(isSelected ? .accentColor : .secondary)
            .frame(width: buttonSize, height: buttonSize)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            )
        }
        .buttonStyle(ScaledButtonStyle())
    }
}
