import SwiftUI

/// Search bar component with version-aware background styling.
/// Background is applied via SearchBarBackgroundModifier which automatically selects:
/// - iOS 26+: Liquid Glass effect
/// - iOS 15-18: ultraThinMaterial fallback
struct FATSearchBar: View {
    @Binding var text: String
    let placeholder: String
    @Binding var isVisible: Bool
    let shouldFocus: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 16))
            
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .onChange(of: shouldFocus) { newValue in
                    if newValue {
                        // Delay focus to avoid UI hang
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isFocused = true
                        }
                    }
                }
            
            if !text.isEmpty {
                Button(action: {
                    withAnimation(.easeOut(duration: 0.1)) {
                        text = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        // Version-aware background: Liquid Glass on iOS 26+, ultraThinMaterial on iOS 15-18
        .modifier(SearchBarBackgroundModifier())
    }
}
