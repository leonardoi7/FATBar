// FATBar-iOS/ContentView.swift
import SwiftUI
import FATBar

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showingAddSheet = false
    @State private var showingFilterSheet = false
    
    var tabs: [FATTabItem] {
        [
            FATTabItem(icon: "house.fill", title: "Home", view: HomeView()),
            FATTabItem(icon: "square.grid.2x2.fill", title: "Browse", view: BrowseView()),
            FATTabItem(icon: "heart.fill", title: "Favorites", view: FavoritesView()),
            FATTabItem(icon: "person.fill", title: "Profile", view: ProfileView())
        ]
    }
    
    var currentActionButtons: [FATActionButton] {
        switch selectedTab {
        case 0: // Home
            return [
                FATActionButton(icon: "plus.circle.fill", action: {
                    showingAddSheet = true
                }),
                FATActionButton(icon: "bell.fill", title: "Alerts", isWide: true, action: {
                    print("Alerts tapped")
                })
            ]
        case 1: // Browse
            return [
                FATActionButton(icon: "slider.horizontal.3", action: {
                    showingFilterSheet = true
                }),
                FATActionButton(icon: "arrow.up.arrow.down.circle.fill", action: {
                    print("Sort tapped")
                })
            ]
        case 2: // Favorites
            return [
                FATActionButton(icon: "square.and.arrow.up.fill", action: {
                    print("Share tapped")
                })
            ]
        default: // Profile
            return [
                FATActionButton(icon: "gearshape.fill", action: {
                    print("Settings tapped")
                })
            ]
        }
    }
    
    var isSearchEnabled: Bool {
        selectedTab == 0 || selectedTab == 1
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
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
                .padding(.bottom, 10)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedTab)
        .sheet(isPresented: $showingAddSheet) {
            AddItemSheet()
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheet()
        }
    }
}

// MARK: - Tab Views

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.2))
                            .frame(height: 150)
                            .overlay(
                                Text("Home Item \(index + 1)")
                                    .font(.headline)
                            )
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
        }
    }
}

struct BrowseView: View {
    let categories = ["Technology", "Design", "Business", "Health", "Education"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(categories, id: \.self) { category in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.purple.opacity(0.2))
                            .frame(height: 100)
                            .overlay(
                                VStack {
                                    Image(systemName: "folder.fill")
                                        .font(.largeTitle)
                                    Text(category)
                                        .font(.caption)
                                }
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Browse")
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { index in
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Favorite Item \(index + 1)")
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
                
                Text("John Doe")
                    .font(.title)
                    .bold()
                
                Text("john.doe@example.com")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Sheets

struct AddItemSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add New Item")
                    .font(.headline)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FilterSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Categories") {
                    ForEach(["All", "Technology", "Design", "Business"], id: \.self) { category in
                        HStack {
                            Text(category)
                            Spacer()
                            Image(systemName: "checkmark")
                                .opacity(category == "All" ? 1 : 0)
                        }
                    }
                }
                
                Section("Sort By") {
                    ForEach(["Newest", "Popular", "A-Z"], id: \.self) { sort in
                        HStack {
                            Text(sort)
                            Spacer()
                            Image(systemName: "checkmark")
                                .opacity(sort == "Newest" ? 1 : 0)
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
