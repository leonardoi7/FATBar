import SwiftUI

// MARK: - Example Implementation

/// Example implementation showing how to use FATBar in your app.
/// This can be used as a reference or copied into your own project.
public struct FATBarExampleView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    
    var tabs: [FATTabItem] {
        [
            FATTabItem(icon: "house", title: "Home", view: ExampleHomeView()),
            FATTabItem(icon: "square.grid.2x2", title: "Browse", view: ExampleBrowseView()),
            FATTabItem(icon: "heart", title: "Favorites", view: ExampleFavoritesView()),
            FATTabItem(icon: "person", title: "Profile", view: ExampleProfileView())
        ]
    }
    
    var currentActionButtons: [FATActionButton] {
        switch selectedTab {
        case 0: // Home
            return [
                FATActionButton(icon: "plus", action: { print("Add tapped") }),
                FATActionButton(icon: "bell", title: "Alerts", isWide: true, action: { print("Alerts tapped") })
            ]
        case 1: // Browse
            return [
                FATActionButton(icon: "slider.horizontal.3", action: { print("Filter tapped") }),
                FATActionButton(icon: "arrow.up.arrow.down", action: { print("Sort tapped") })
            ]
        case 2: // Favorites
            return [
                FATActionButton(icon: "square.and.arrow.up", action: { print("Share tapped") })
            ]
        default: // Profile
            return []
        }
    }
    
    var isSearchEnabled: Bool {
        selectedTab == 0 || selectedTab == 1 // Enable search for Home and Browse
    }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Background
            #if os(iOS)
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            #else
            Color.clear
                .ignoresSafeArea()
            #endif
            
            // Current Tab Content
            tabs[selectedTab].view
                .transition(.opacity)
            
            // Floating Action Tab Bar
            VStack {
                Spacer()
                
                FATBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    actionButtons: currentActionButtons,
                    searchEnabled: isSearchEnabled,
                    searchPlaceholder: "Search \(tabs[selectedTab].title)...",
                    searchText: $searchText
                )
                .padding(.bottom, 20)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedTab)
    }
}

// MARK: - Example Views

struct ExampleHomeView: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .bold()
            Text("Search enabled, 2 action buttons")
                .foregroundColor(.secondary)
        }
    }
}

struct ExampleBrowseView: View {
    var body: some View {
        VStack {
            Text("Browse")
                .font(.largeTitle)
                .bold()
            Text("Search enabled, 2 action buttons")
                .foregroundColor(.secondary)
        }
    }
}

struct ExampleFavoritesView: View {
    var body: some View {
        VStack {
            Text("Favorites")
                .font(.largeTitle)
                .bold()
            Text("No search, 1 action button")
                .foregroundColor(.secondary)
        }
    }
}

struct ExampleProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .bold()
            Text("No search, no action buttons")
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

struct FATBarExampleView_Previews: PreviewProvider {
    static var previews: some View {
        FATBarExampleView()
    }
}
