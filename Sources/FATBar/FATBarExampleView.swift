import SwiftUI

// MARK: - Example Implementation

/// Example implementation showing how to use FATBar in your app.
/// This can be used as a reference or copied into your own project.
/// Includes visual indicators to help verify iOS version-specific behavior.
public struct FATBarExampleView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showVersionInfo = true
    
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
            
            // Version Info Banner (top)
            if showVersionInfo {
                VStack {
                    versionInfoBanner
                        .padding(.horizontal)
                        .padding(.top, 50)
                    Spacer()
                }
            }
            
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
        .onAppear {
            logVersionInfo()
        }
    }
    
    // MARK: - Version Info Banner
    
    @ViewBuilder
    private var versionInfoBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                
                Text("FATBar Version Test")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { showVersionInfo.toggle() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("iOS Version:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(getIOSVersion())
                        .font(.caption)
                        .bold()
                }
                
                HStack {
                    Text("UI Mode:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(getUIMode())
                        .font(.caption)
                        .bold()
                        .foregroundColor(isLiquidGlassAvailable() ? .green : .orange)
                }
                
                HStack {
                    Text("Features:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(getFeaturesList())
                        .font(.caption)
                }
            }
            
            Text("Tap tabs and action buttons to test all features")
                .font(.caption2)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(secondaryBackgroundColor)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        )
    }
    
    // MARK: - Helper Methods
    
    private func getIOSVersion() -> String {
        #if os(iOS)
        let version = UIDevice.current.systemVersion
        return "iOS \(version)"
        #else
        return "Non-iOS Platform"
        #endif
    }
    
    private func getUIMode() -> String {
        if #available(iOS 26, *) {
            return "Liquid Glass (iOS 26+)"
        } else {
            return "Fallback UI (iOS 15-18)"
        }
    }
    
    private func isLiquidGlassAvailable() -> Bool {
        if #available(iOS 26, *) {
            return true
        }
        return false
    }
    
    private func getFeaturesList() -> String {
        var features: [String] = []
        
        if isSearchEnabled {
            features.append("Search")
        }
        
        if !currentActionButtons.isEmpty {
            features.append("\(currentActionButtons.count) Action Button\(currentActionButtons.count > 1 ? "s" : "")")
        }
        
        features.append("\(tabs.count) Tabs")
        
        return features.joined(separator: ", ")
    }
    
    private func logVersionInfo() {
        print("=== FATBar Version Test ===")
        print("iOS Version: \(getIOSVersion())")
        print("UI Mode: \(getUIMode())")
        print("Liquid Glass Available: \(isLiquidGlassAvailable())")
        print("Current Tab: \(tabs[selectedTab].title)")
        print("Search Enabled: \(isSearchEnabled)")
        print("Action Buttons: \(currentActionButtons.count)")
        print("========================")
    }
}

// MARK: - Example Views

// Helper for cross-platform background color
private var secondaryBackgroundColor: Color {
    #if os(iOS)
    return Color(uiColor: .secondarySystemBackground)
    #elseif os(macOS)
    return Color(nsColor: .controlBackgroundColor)
    #else
    return Color.gray.opacity(0.2)
    #endif
}

struct ExampleHomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "house.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Home")
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureIndicator(icon: "magnifyingglass", text: "Search enabled", isActive: true)
                    FeatureIndicator(icon: "plus.circle", text: "Add button", isActive: true)
                    FeatureIndicator(icon: "bell", text: "Alerts button (wide)", isActive: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(secondaryBackgroundColor)
                )
                .padding(.horizontal)
                
                Text("Try searching or tapping the action buttons")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.vertical, 40)
        }
    }
}

struct ExampleBrowseView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "square.grid.2x2.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text("Browse")
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureIndicator(icon: "magnifyingglass", text: "Search enabled", isActive: true)
                    FeatureIndicator(icon: "slider.horizontal.3", text: "Filter button", isActive: true)
                    FeatureIndicator(icon: "arrow.up.arrow.down", text: "Sort button", isActive: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(secondaryBackgroundColor)
                )
                .padding(.horizontal)
                
                Text("Search for categories or use filter/sort")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.vertical, 40)
        }
    }
}

struct ExampleFavoritesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                Text("Favorites")
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureIndicator(icon: "magnifyingglass", text: "Search disabled", isActive: false)
                    FeatureIndicator(icon: "square.and.arrow.up", text: "Share button", isActive: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(secondaryBackgroundColor)
                )
                .padding(.horizontal)
                
                Text("Notice how search bar is hidden on this tab")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.vertical, 40)
        }
    }
}

struct ExampleProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureIndicator(icon: "magnifyingglass", text: "Search disabled", isActive: false)
                    FeatureIndicator(icon: "circle.slash", text: "No action buttons", isActive: false)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(secondaryBackgroundColor)
                )
                .padding(.horizontal)
                
                Text("Minimal UI - just tab navigation")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.vertical, 40)
        }
    }
}

// MARK: - Supporting Views

struct FeatureIndicator: View {
    let icon: String
    let text: String
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(isActive ? .green : .secondary)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(isActive ? .primary : .secondary)
            
            Spacer()
            
            Image(systemName: isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isActive ? .green : .secondary)
        }
    }
}

// MARK: - Preview

struct FATBarExampleView_Previews: PreviewProvider {
    static var previews: some View {
        FATBarExampleView()
    }
}
