//
//  MainViewTests.swift
//  UnlockITUITests
//
//  Created by Anton Lage on 28/04/2023.
//

import XCTest


final class MainViewTests: XCTestCase {
    let app = XCUIApplication()
    var userSetupHelper: UserSetupHelper? = nil
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI_TESTING"]
        userSetupHelper = UserSetupHelper(app: app)
        userSetupHelper!.configureDefaultUser()
        
    }
    
    func testAdminControlsAvaliableForAdmin() throws {
        // UI tests must launch the application that they test.
        userSetupHelper!.configureUserAdminStatus(isAdmin: "TRUE")
        app.launch()
        
        let homeButton = app.buttons["TabbarHomeButton"]
        let bookedRoomsButton = app.buttons["TabbarBookedRoomsButton"]
        let adminControlsButton = app.buttons["TabbarAdminControlsButton"]
        
        XCTAssertTrue(homeButton.exists)
        XCTAssertTrue(bookedRoomsButton.exists)
        
        XCTAssertTrue(adminControlsButton.exists, "Admin controls button not visible for admin")
        XCTAssertEqual(adminControlsButton.label, "Admin Controls")
    }
    
    
    
    
    
    
    func testAdminControlsNotAvaliableForNonAdmin() throws {
        userSetupHelper!.configureUserAdminStatus(isAdmin: "FALSE")
        app.launch()
        
        let homeButton = app.tabBars["Fanelinje"].buttons["Home"]
        let bookedRoomsButton = app.tabBars["Fanelinje"].buttons["Booked Rooms"]
        let adminControlsButton = app.tabBars["Fanelinje"].buttons["Admin Controls"]
        
        XCTAssertTrue(homeButton.exists)
        XCTAssertTrue(bookedRoomsButton.exists)
        XCTAssertFalse(adminControlsButton.exists, "Admin button is visible for non admin")
    }
}
