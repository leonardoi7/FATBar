import SwiftUI

// MARK: - Public API

/// A floating action tab bar that provides tab navigation with optional action buttons and search functionality.
///
/// FATBar supports iOS 15+ with automatic version detection:
/// - iOS 26+: Uses Liquid Glass effects for premium visual appearance
/// - iOS 15-18: Uses ultraThinMaterial fallback for polished blur effects
///
/// Version detection happens automatically at runtime via ViewModifiers, requiring no conditional
/// code in your app. The public API remains identical across all iOS versions.
public struct FATBar: View {
    @Binding var selectedTab: Int
    let tabs: [FATTabItem]
    let actionButtons: [FATActionButton]
    let searchEnabled: Bool
    let searchPlaceholder: String
    @Binding var searchText: String
    @State private var isSearchVisible = false
    @State private var searchBarOpacity: Double = 0
    
    private let buttonSize: CGFloat = 52
    private let wideButtonWidth: CGFloat = 96
    private let spacing: CGFloat = 10
    
    /// Creates a new floating action tab bar.
    /// - Parameters:
    ///   - selectedTab: Binding to the currently selected tab index
    ///   - tabs: Array of tab items to display
    ///   - actionButtons: Optional action buttons to display above the tab bar
    ///   - searchEnabled: Whether to show search functionality
    ///   - searchPlaceholder: Placeholder text for the search field
    ///   - searchText: Binding to the search text
    public init(
        selectedTab: Binding<Int>,
        tabs: [FATTabItem],
        actionButtons: [FATActionButton] = [],
        searchEnabled: Bool = false,
        searchPlaceholder: String = "Search...",
        searchText: Binding<String> = .constant("")
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.actionButtons = actionButtons
        self.searchEnabled = searchEnabled
        self.searchPlaceholder = searchPlaceholder
        self._searchText = searchText
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            // Search Bar with optimized rendering
            if searchEnabled && isSearchVisible {
                FATSearchBar(
                    text: $searchText,
                    placeholder: searchPlaceholder,
                    isVisible: $isSearchVisible,
                    shouldFocus: searchBarOpacity > 0.9
                )
                .opacity(searchBarOpacity)
                .scaleEffect(searchBarOpacity > 0.5 ? 1 : 0.9)
                .transition(.scale.combined(with: .opacity))
                .onAppear {
                    // Defer animation to next run loop
                    DispatchQueue.main.async {
                        withAnimation(.easeOut(duration: 0.2)) {
                            searchBarOpacity = 1
                        }
                    }
                }
                .onDisappear {
                    searchBarOpacity = 0
                }
            }
            
            // Unified Container for Action Buttons and Tab Bar
            // Background is applied via MainContainerBackgroundModifier which handles version detection
            VStack(spacing: 8) {
                // Action Buttons
                if !actionButtons.isEmpty || searchEnabled {
                    HStack(spacing: spacing) {
                        // Search Toggle Button
                        if searchEnabled {
                            Button(action: toggleSearch) {
                                Image(systemName: isSearchVisible ? "xmark" : "magnifyingglass")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                                    .frame(width: buttonSize, height: buttonSize)
                                    .contentShape(Rectangle())  // Ensure entire frame is tappable
                            }
                            .buttonStyle(ScaledButtonStyle())
                            .allowsHitTesting(true)  // Explicitly enable hit testing
                        }
                        
                        // Action Buttons
                        ForEach(actionButtons) { button in
                            FATActionButtonView(button: button)
                        }
                    }
                }
                
                // Tab Bar
                HStack(spacing: spacing) {
                    ForEach(tabs.indices, id: \.self) { index in
                        FATTabButton(
                            tab: tabs[index],
                            isSelected: selectedTab == index,
                            action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTab = index
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            // Version-aware background: Liquid Glass on iOS 26+, ultraThinMaterial on iOS 15-18
            .modifier(MainContainerBackgroundModifier())
        }
        .padding(.horizontal, 20)
    }
    
    private func toggleSearch() {
        if isSearchVisible {
            // Clear search and hide immediately
            searchText = ""
            withAnimation(.easeIn(duration: 0.15)) {
                isSearchVisible = false
            }
        } else {
            // Show search bar
            withAnimation(.easeOut(duration: 0.2)) {
                isSearchVisible = true
            }
        }
    }
}
