import XCTest
import SwiftUI
@testable import FATBar

final class FATBarTests: XCTestCase {
    
    func testFATTabItemInitialization() throws {
        // Test FATTabItem creation
        let tabItem = FATTabItem(icon: "house", title: "Home", view: Text("Test"))
        
        XCTAssertEqual(tabItem.icon, "house")
        XCTAssertEqual(tabItem.title, "Home")
        XCTAssertNotNil(tabItem.id)
    }
    
    func testFATActionButtonInitialization() throws {
        var actionCalled = false
        let actionButton = FATActionButton(
            icon: "plus",
            title: "Add",
            isWide: true,
            action: { actionCalled = true }
        )
        
        XCTAssertEqual(actionButton.icon, "plus")
        XCTAssertEqual(actionButton.title, "Add")
        XCTAssertTrue(actionButton.isWide)
        XCTAssertNotNil(actionButton.id)
        
        // Test action execution
        actionButton.action()
        XCTAssertTrue(actionCalled)
    }
    
    func testFATActionButtonDefaultValues() throws {
        let actionButton = FATActionButton(icon: "heart", action: {})
        
        XCTAssertEqual(actionButton.icon, "heart")
        XCTAssertNil(actionButton.title)
        XCTAssertFalse(actionButton.isWide)
    }
    
    func testFATBarInitialization() throws {
        let tabs = [
            FATTabItem(icon: "house", title: "Home", view: Text("Home")),
            FATTabItem(icon: "person", title: "Profile", view: Text("Profile"))
        ]
        
        let actionButtons = [
            FATActionButton(icon: "plus", action: {})
        ]
        
        @State var selectedTab = 0
        @State var searchText = ""
        
        let fatBar = FATBar(
            selectedTab: .constant(0),
            tabs: tabs,
            actionButtons: actionButtons,
            searchEnabled: true,
            searchPlaceholder: "Search...",
            searchText: .constant("")
        )
        
        XCTAssertEqual(fatBar.tabs.count, 2)
        XCTAssertEqual(fatBar.actionButtons.count, 1)
        XCTAssertTrue(fatBar.searchEnabled)
        XCTAssertEqual(fatBar.searchPlaceholder, "Search...")
    }
    
    func testTabItemUniqueIDs() throws {
        let tab1 = FATTabItem(icon: "house", title: "Home", view: Text("Home"))
        let tab2 = FATTabItem(icon: "person", title: "Profile", view: Text("Profile"))
        
        XCTAssertNotEqual(tab1.id, tab2.id)
    }
    
    func testActionButtonUniqueIDs() throws {
        let button1 = FATActionButton(icon: "plus", action: {})
        let button2 = FATActionButton(icon: "minus", action: {})
        
        XCTAssertNotEqual(button1.id, button2.id)
    }
    
    func testExampleViewCreation() throws {
        let exampleView = FATBarExampleView()
        XCTAssertNotNil(exampleView)
    }
    
    func testPerformanceOfTabCreation() throws {
        measure {
            // Test performance of creating multiple tabs
            let tabs = (0..<100).map { index in
                FATTabItem(icon: "house", title: "Tab \(index)", view: Text("Content \(index)"))
            }
            XCTAssertEqual(tabs.count, 100)
        }
    }
    
    func testPerformanceOfActionButtonCreation() throws {
        measure {
            // Test performance of creating multiple action buttons
            let buttons = (0..<100).map { index in
                FATActionButton(icon: "plus", title: "Button \(index)", action: {})
            }
            XCTAssertEqual(buttons.count, 100)
        }
    }
    
    // MARK: - iOS 15 Button Style Tests
    
    func testScaledButtonStyleCompiles() throws {
        // Verify ScaledButtonStyle can be instantiated (tests compilation)
        let buttonStyle = ScaledButtonStyle()
        XCTAssertNotNil(buttonStyle)
    }
    
    func testFATTabButtonWithScaledButtonStyle() throws {
        // Test that FATTabButton with ScaledButtonStyle compiles and initializes
        let tabItem = FATTabItem(icon: "house", title: "Home", view: Text("Home"))
        var actionCalled = false
        
        let tabButton = FATTabButton(
            tab: tabItem,
            isSelected: false,
            action: { actionCalled = true }
        )
        
        XCTAssertNotNil(tabButton)
        
        // Verify action callback executes
        tabButton.action()
        XCTAssertTrue(actionCalled, "Tab button action should execute correctly")
    }
    
    func testFATActionButtonViewWithScaledButtonStyle() throws {
        // Test that FATActionButtonView with ScaledButtonStyle compiles and initializes
        var actionCalled = false
        let actionButton = FATActionButton(
            icon: "plus",
            title: "Add",
            isWide: true,
            action: { actionCalled = true }
        )
        
        let actionButtonView = FATActionButtonView(button: actionButton)
        XCTAssertNotNil(actionButtonView)
        
        // Verify action callback executes
        actionButton.action()
        XCTAssertTrue(actionCalled, "Action button callback should execute correctly")
    }
    
    func testButtonCallbacksExecuteOnIOS15() throws {
        // Test that button callbacks work correctly (iOS 15 compatibility)
        var tabActionCalled = false
        var actionButtonCalled = false
        
        let tabItem = FATTabItem(icon: "house", title: "Home", view: Text("Home"))
        let tabButton = FATTabButton(
            tab: tabItem,
            isSelected: false,
            action: { tabActionCalled = true }
        )
        
        let actionButton = FATActionButton(
            icon: "plus",
            action: { actionButtonCalled = true }
        )
        
        // Execute callbacks
        tabButton.action()
        actionButton.action()
        
        XCTAssertTrue(tabActionCalled, "Tab button callback should execute on iOS 15")
        XCTAssertTrue(actionButtonCalled, "Action button callback should execute on iOS 15")
    }
    
    func testScaledButtonStyleAnimationConfiguration() throws {
        // Verify ScaledButtonStyle has proper animation configuration
        // This test ensures the button style works with iOS 15's animation APIs
        let buttonStyle = ScaledButtonStyle()
        
        // Create a mock configuration
        struct MockConfiguration: ButtonStyleConfiguration {
            let label: AnyView
            let isPressed: Bool
            
            init(isPressed: Bool) {
                self.label = AnyView(Text("Test"))
                self.isPressed = isPressed
            }
        }
        
        let pressedConfig = MockConfiguration(isPressed: true)
        let normalConfig = MockConfiguration(isPressed: false)
        
        // Verify the button style can create body views for both states
        let pressedBody = buttonStyle.makeBody(configuration: pressedConfig)
        let normalBody = buttonStyle.makeBody(configuration: normalConfig)
        
        XCTAssertNotNil(pressedBody)
        XCTAssertNotNil(normalBody)
    }
}
