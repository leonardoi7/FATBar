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
}
