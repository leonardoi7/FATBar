# FATBar - Floating Action Tab Bar

A customizable floating action tab bar for SwiftUI that combines tab navigation with contextual action buttons and optional search functionality.

## Features

- 🚀 **Floating Design**: Beautiful glassmorphism effect with shadow
- 📱 **Tab Navigation**: Clean tab interface with selection indicators
- ⚡ **Action Buttons**: Contextual action buttons that change per tab
- 🔍 **Search Integration**: Optional search functionality with animations
- 🎨 **Customizable**: Fully customizable icons, titles, and actions
- ✨ **Smooth Animations**: Spring-based animations throughout

## Installation

### Swift Package Manager

Add FATBar to your project using Swift Package Manager:

1. In Xcode, go to **File > Add Package Dependencies...**
2. Enter the repository URL
3. Select the version you want to use

Alternatively, add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/FATBar", from: "1.0.0")
]
```

## Usage

### Basic Implementation

```swift
import SwiftUI
import FATBar

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    
    var tabs: [FATTabItem] {
        [
            FATTabItem(icon: "house", title: "Home", view: HomeView()),
            FATTabItem(icon: "square.grid.2x2", title: "Browse", view: BrowseView()),
            FATTabItem(icon: "heart", title: "Favorites", view: FavoritesView()),
            FATTabItem(icon: "person", title: "Profile", view: ProfileView())
        ]
    }
    
    var body: some View {
        ZStack {
            // Your main content
            tabs[selectedTab].view
            
            // Floating Action Tab Bar
            VStack {
                Spacer()
                FATBar(
                    selectedTab: $selectedTab,
                    tabs: tabs
                )
                .padding(.bottom, 20)
            }
        }
    }
}
```

### With Action Buttons

```swift
var actionButtons: [FATActionButton] {
    [
        FATActionButton(icon: "plus", action: { print("Add tapped") }),
        FATActionButton(icon: "bell", title: "Alerts", isWide: true, action: { print("Alerts tapped") })
    ]
}

FATBar(
    selectedTab: $selectedTab,
    tabs: tabs,
    actionButtons: actionButtons
)
```

### With Search

```swift
FATBar(
    selectedTab: $selectedTab,
    tabs: tabs,
    actionButtons: actionButtons,
    searchEnabled: true,
    searchPlaceholder: "Search content...",
    searchText: $searchText
)
```

## API Reference

### FATBar

The main component that displays the floating action tab bar.

#### Initializer

```swift
public init(
    selectedTab: Binding<Int>,
    tabs: [FATTabItem],
    actionButtons: [FATActionButton] = [],
    searchEnabled: Bool = false,
    searchPlaceholder: String = "Search...",
    searchText: Binding<String> = .constant("")
)
```

#### Parameters

- `selectedTab`: Binding to the currently selected tab index
- `tabs`: Array of tab items to display
- `actionButtons`: Optional action buttons to display above the tab bar
- `searchEnabled`: Whether to show search functionality
- `searchPlaceholder`: Placeholder text for the search field
- `searchText`: Binding to the search text

### FATTabItem

Represents a tab item in the floating action tab bar.

```swift
public init<V: View>(icon: String, title: String, view: V)
```

#### Parameters

- `icon`: SF Symbol name for the tab icon
- `title`: Title of the tab
- `view`: The view to display when this tab is selected

### FATActionButton

Represents an action button that can be displayed above the tab bar.

```swift
public init(icon: String, title: String? = nil, isWide: Bool = false, action: @escaping () -> Void)
```

#### Parameters

- `icon`: SF Symbol name for the button icon
- `title`: Optional title text (only displayed if isWide is true)
- `isWide`: Whether the button should be wider to accommodate title text
- `action`: Action to perform when the button is tapped

## Example

Check out `FATBarExampleView` for a complete implementation example that demonstrates:

- Multiple tabs with different content
- Contextual action buttons that change per tab
- Search functionality enabled for specific tabs
- Smooth animations and transitions

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- Swift 5.5+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
