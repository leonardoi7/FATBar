import SwiftUI

// MARK: - Public API

/// A floating action tab bar that provides tab navigation with optional action buttons and search functionality.
public struct FATBar: View {
    @Binding var selectedTab: Int
    let tabs: [FATTabItem]
    let actionButtons: [FATActionButton]
    let searchEnabled: Bool
    let searchPlaceholder: String
    @Binding var searchText: String
    @State private var isSearchVisible = false
    @State private var searchBarOpacity: Double = 0
    
    private let buttonSize: CGFloat = 44
    private let wideButtonWidth: CGFloat = 88
    private let spacing: CGFloat = 8
    
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
                                .background(Color(UIColor.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(ScaledButtonStyle())
                    }
                    
                    // Action Buttons
                    ForEach(actionButtons) { button in
                        FATActionButtonView(button: button)
                            .buttonStyle(ScaledButtonStyle())
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
                    .buttonStyle(ScaledButtonStyle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        )
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
