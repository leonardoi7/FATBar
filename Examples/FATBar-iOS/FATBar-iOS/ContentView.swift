// FATBar-iOS/ContentView.swift
import SwiftUI
import FATBar

struct ContentView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var browseViewModel = BrowseViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showingAddSheet = false
    @State private var showingFilterSheet = false
    @State private var showingSettingsSheet = false
    
    var tabs: [FATTabItem] {
        [
            FATTabItem(icon: "house.fill", title: "Home", view: HomeView(viewModel: homeViewModel, searchText: searchText), showLabel: true),
            FATTabItem(icon: "square.grid.2x2.fill", title: "Browse", view: BrowseView(viewModel: browseViewModel, searchText: searchText), showLabel: true),
            FATTabItem(icon: "heart.fill", title: "Favorites", view: FavoritesView(viewModel: favoritesViewModel), showLabel: true),
            FATTabItem(icon: "person.fill", title: "Profile", view: ProfileView(viewModel: profileViewModel), showLabel: true)
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
                    homeViewModel.showNotifications()
                })
            ]
        case 1: // Browse
            return [
                FATActionButton(icon: "slider.horizontal.3", action: {
                    showingFilterSheet = true
                }),
                FATActionButton(icon: "arrow.up.arrow.down.circle.fill", action: {
                    browseViewModel.toggleSortOrder()
                })
            ]
        case 2: // Favorites
            return [
                FATActionButton(icon: "square.and.arrow.up.fill", action: {
                    favoritesViewModel.shareAllFavorites()
                }),
                FATActionButton(icon: "trash.fill", action: {
                    favoritesViewModel.clearAllFavorites()
                })
            ]
        default: // Profile
            return [
                FATActionButton(icon: "gearshape.fill", action: {
                    showingSettingsSheet = true
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
                    searchPlaceholder: getSearchPlaceholder(),
                    searchText: $searchText
                )
                .padding(.bottom, 10)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedTab)
        .onChange(of: selectedTab) { _ in
            // Clear search when switching tabs
            searchText = ""
        }
        .onChange(of: searchText) { newValue in
            // Update search in appropriate ViewModels
            if selectedTab == 0 {
                homeViewModel.updateSearch(newValue)
            } else if selectedTab == 1 {
                browseViewModel.updateSearch(newValue)
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddItemSheet(homeViewModel: homeViewModel)
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheet(browseViewModel: browseViewModel)
        }
        .sheet(isPresented: $showingSettingsSheet) {
            SettingsSheet(profileViewModel: profileViewModel)
        }
    }
    
    private func getSearchPlaceholder() -> String {
        switch selectedTab {
        case 0: return "Search articles..."
        case 1: return "Search categories..."
        default: return "Search..."
        }
    }
}

// MARK: - Models

struct Article: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
    let category: String
    let publishDate: Date
    var isFavorite: Bool = false
    
    static let sampleArticles = [
        Article(title: "SwiftUI Animation Mastery", content: "Learn advanced animation techniques in SwiftUI", category: "Technology", publishDate: Date().addingTimeInterval(-86400)),
        Article(title: "Design System Fundamentals", content: "Building consistent design systems", category: "Design", publishDate: Date().addingTimeInterval(-172800)),
        Article(title: "Business Strategy in 2024", content: "Key trends and strategies for modern business", category: "Business", publishDate: Date().addingTimeInterval(-259200)),
        Article(title: "Mental Health in Tech", content: "Maintaining wellbeing in the tech industry", category: "Health", publishDate: Date().addingTimeInterval(-432000)),
        Article(title: "Online Learning Revolution", content: "The future of digital education", category: "Education", publishDate: Date().addingTimeInterval(-345600)),
        Article(title: "iOS App Performance", content: "Optimizing your iOS applications", category: "Technology", publishDate: Date().addingTimeInterval(-604800)),
        Article(title: "UX Research Methods", content: "Essential methods for user experience research", category: "Design", publishDate: Date().addingTimeInterval(-518400)),
        Article(title: "Startup Funding Guide", content: "A comprehensive guide to raising capital", category: "Business", publishDate: Date().addingTimeInterval(-777600)),
        Article(title: "Mindfulness at Work", content: "Incorporating mindfulness into your workday", category: "Health", publishDate: Date().addingTimeInterval(-86400)),
        Article(title: "Remote Learning Best Practices", content: "Effective strategies for online education", category: "Education", publishDate: Date().addingTimeInterval(-96000))
    ]
}

struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let articleCount: Int
    
    static let categories = [
        Category(name: "Technology", icon: "laptopcomputer", color: .blue, articleCount: 25),
        Category(name: "Design", icon: "paintbrush.fill", color: .purple, articleCount: 18),
        Category(name: "Business", icon: "briefcase.fill", color: .green, articleCount: 32),
        Category(name: "Health", icon: "heart.fill", color: .red, articleCount: 14),
        Category(name: "Education", icon: "book.fill", color: .orange, articleCount: 21)
    ]
}

// MARK: - ViewModels

@MainActor
class HomeViewModel: ObservableObject {
    @Published var articles: [Article] = Article.sampleArticles
    @Published var filteredArticles: [Article] = Article.sampleArticles
    @Published var isLoading = false
    @Published var showingNotifications = false
    
    private var searchText = ""
    
    init() {
        loadArticles()
    }
    
    func loadArticles() {
        isLoading = true
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
    
    func updateSearch(_ text: String) {
        searchText = text
        if text.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter { article in
                article.title.localizedCaseInsensitiveContains(text) ||
                article.content.localizedCaseInsensitiveContains(text) ||
                article.category.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    func toggleFavorite(for article: Article) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isFavorite.toggle()
            updateSearch(searchText) // Refresh filtered results
        }
    }
    
    func addArticle(_ article: Article) {
        articles.insert(article, at: 0)
        updateSearch(searchText)
    }
    
    func showNotifications() {
        showingNotifications = true
        // Handle notification display logic
        print("Showing notifications")
    }
}

@MainActor
class BrowseViewModel: ObservableObject {
    @Published var categories: [Category] = Category.categories
    @Published var filteredCategories: [Category] = Category.categories
    @Published var sortOrder: SortOrder = .alphabetical
    @Published var isLoading = false
    
    enum SortOrder: CaseIterable {
        case alphabetical, articleCount, newest
        
        var title: String {
            switch self {
            case .alphabetical: return "A-Z"
            case .articleCount: return "Most Articles"
            case .newest: return "Newest"
            }
        }
    }
    
    private var searchText = ""
    
    func updateSearch(_ text: String) {
        searchText = text
        if text.isEmpty {
            filteredCategories = categories
        } else {
            filteredCategories = categories.filter { category in
                category.name.localizedCaseInsensitiveContains(text)
            }
        }
        applySorting()
    }
    
    func toggleSortOrder() {
        let allCases = SortOrder.allCases
        if let currentIndex = allCases.firstIndex(of: sortOrder) {
            let nextIndex = (currentIndex + 1) % allCases.count
            sortOrder = allCases[nextIndex]
            applySorting()
        }
    }
    
    func setSortOrder(_ order: SortOrder) {
        sortOrder = order
        applySorting()
    }
    
    private func applySorting() {
        switch sortOrder {
        case .alphabetical:
            filteredCategories.sort { $0.name < $1.name }
        case .articleCount:
            filteredCategories.sort { $0.articleCount > $1.articleCount }
        case .newest:
            // For demo purposes, reverse alphabetical
            filteredCategories.sort { $0.name > $1.name }
        }
    }
}

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteArticles: [Article] = []
    @Published var isLoading = false
    
    init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        isLoading = true
        // Simulate loading favorites
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.favoriteArticles = Article.sampleArticles.filter { $0.isFavorite }
            self.isLoading = false
        }
    }
    
    func removeFavorite(_ article: Article) {
        favoriteArticles.removeAll { $0.id == article.id }
    }
    
    func shareAllFavorites() {
        print("Sharing \(favoriteArticles.count) favorites")
        // Implement sharing logic
    }
    
    func clearAllFavorites() {
        favoriteArticles.removeAll()
        print("Cleared all favorites")
    }
}

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User = User.sampleUser
    @Published var isEditing = false
    @Published var showingSettings = false
    
    struct User {
        var name: String
        var email: String
        var bio: String
        var joinDate: Date
        var articlesRead: Int
        var favoriteCount: Int
        
        static let sampleUser = User(
            name: "John Doe",
            email: "john.doe@example.com",
            bio: "Passionate about technology and continuous learning.",
            joinDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
            articlesRead: 147,
            favoriteCount: 23
        )
    }
    
    func updateProfile(name: String, bio: String) {
        user.name = name
        user.bio = bio
        isEditing = false
    }
    
    func signOut() {
        print("Signing out user")
        // Implement sign out logic
    }
}

// MARK: - Views

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    let searchText: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredArticles) { article in
                        ArticleCard(article: article) {
                            viewModel.toggleFavorite(for: article)
                        }
                    }
                    
                    if viewModel.filteredArticles.isEmpty && !searchText.isEmpty {
                        EmptySearchView(searchText: searchText)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationTitle("Home")
            .refreshable {
                viewModel.loadArticles()
            }
        }
    }
}

struct BrowseView: View {
    @ObservedObject var viewModel: BrowseViewModel
    let searchText: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Sort indicator
                    HStack {
                        Text("Sorted by: \(viewModel.sortOrder.title)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.filteredCategories) { category in
                            CategoryCard(category: category)
                        }
                    }
                    .padding(.horizontal)
                    
                    if viewModel.filteredCategories.isEmpty && !searchText.isEmpty {
                        EmptySearchView(searchText: searchText)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Browse")
        }
    }
}

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.favoriteArticles.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("No Favorites Yet")
                            .font(.title2)
                            .bold()
                        Text("Articles you favorite will appear here")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.favoriteArticles) { article in
                            FavoriteArticleRow(article: article) {
                                viewModel.removeFavorite(article)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
}

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text(viewModel.user.name)
                            .font(.title)
                            .bold()
                        
                        Text(viewModel.user.email)
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.user.bio)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Stats
                    HStack(spacing: 40) {
                        StatView(title: "Articles Read", value: "\(viewModel.user.articlesRead)")
                        StatView(title: "Favorites", value: "\(viewModel.user.favoriteCount)")
                        StatView(title: "Member Since", value: DateFormatter.year.string(from: viewModel.user.joinDate))
                    }
                    
                    // Actions
                    VStack(spacing: 12) {
                        Button(action: { viewModel.isEditing = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Profile")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: viewModel.signOut) {
                            HStack {
                                Image(systemName: "arrow.right.square")
                                Text("Sign Out")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $viewModel.isEditing) {
                EditProfileSheet(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Supporting Views

struct ArticleCard: View {
    let article: Article
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(article.content)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: article.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(article.isFavorite ? .red : .secondary)
                        .font(.title3)
                }
            }
            
            HStack {
                Text(article.category)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                
                Spacer()
                
                Text(DateFormatter.relative.string(from: article.publishDate))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.largeTitle)
                .foregroundColor(category.color)
            
            Text(category.name)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("\(category.articleCount) articles")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(category.color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct FavoriteArticleRow: View {
    let article: Article
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(article.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct EmptySearchView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("No results for '\(searchText)'")
                .font(.headline)
            
            Text("Try adjusting your search terms")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 40)
    }
}

// MARK: - Sheets

struct AddItemSheet: View {
    @Environment(\.dismiss) var dismiss
    let homeViewModel: HomeViewModel
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedCategory = "Technology"
    
    let categories = ["Technology", "Design", "Business", "Health", "Education"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Article Details") {
                    TextField("Title", text: $title)
                    TextField("Content", text: $content)
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Article")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newArticle = Article(title: title, content: content, category: selectedCategory, publishDate: Date())
                        homeViewModel.addArticle(newArticle)
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }

        }
    }
}

struct FilterSheet: View {
    @Environment(\.dismiss) var dismiss
    let browseViewModel: BrowseViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sort By") {
                    ForEach(BrowseViewModel.SortOrder.allCases, id: \.self) { sortOrder in
                        HStack {
                            Text(sortOrder.title)
                            Spacer()
                            if browseViewModel.sortOrder == sortOrder {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            browseViewModel.setSortOrder(sortOrder)
                        }
                    }
                }
            }
            .navigationTitle("Sort Options")
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

struct SettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    let profileViewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Account") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(profileViewModel.user.name)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(profileViewModel.user.email)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Preferences") {
                    HStack {
                        Text("Notifications")
                        Spacer()
                        Toggle("", isOn: .constant(true))
                    }
                    
                    HStack {
                        Text("Dark Mode")
                        Spacer()
                        Toggle("", isOn: .constant(false))
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
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

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: ProfileViewModel
    
    @State private var name: String
    @State private var bio: String
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self._name = State(initialValue: viewModel.user.name)
        self._bio = State(initialValue: viewModel.user.bio)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile Information") {
                    TextField("Name", text: $name)
                    TextField("Bio", text: $bio)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.updateProfile(name: name, bio: bio)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let relative: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    static let year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
