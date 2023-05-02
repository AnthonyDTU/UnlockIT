//
//  ManageUsersUITests.swift
//  UnlockITUITests
//
//  Created by Anton Lage on 28/04/2023.
//

import XCTest

final class ManageUsersUITests: XCTestCase {
    let app = XCUIApplication()
    var userSetupHelper: UserSetupHelper? = nil
    
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI_TESTING"]
        userSetupHelper = UserSetupHelper(app: app)
        userSetupHelper!.configureDefaultUser()
    }

    func testNumberOfUsersPluralRulesForZeroUsers() throws {
        // UI tests must launch the application that they test.
        let _ = UserbaseSetupHelper(app: app, numberOfUsersInUserbase: "0")
        app.launch()
        navigateToManageUsers()
        
        let expectation = XCTestExpectation(description: "Label Is Correct")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            //then
            XCTAssertTrue(self.app.collectionViews.staticTexts["No Users"].exists)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3.0)
    }
    
    
    func testNumberOfUsersPluralRulesForOneUser(){
        // UI tests must launch the application that they test.
        let _ = UserbaseSetupHelper(app: app, numberOfUsersInUserbase: "1")
        app.launch()
        navigateToManageUsers()
        
        let expectation = XCTestExpectation(description: "Label Is Correct")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            //then
            XCTAssertTrue(self.app.collectionViews.staticTexts["1 User"].exists)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testNumberOfUsersPluralRulesForMultipleUsers(){
        // UI tests must launch the application that they test.
        let _ = UserbaseSetupHelper(app: app, numberOfUsersInUserbase: "4")
        app.launch()
        navigateToManageUsers()
        
        
        let expectation = XCTestExpectation(description: "Label Is Correct")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            //then
            XCTAssertTrue(self.app.collectionViews.staticTexts["4 Users In Total"].exists)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3.0)
    }
    
    
    func navigateToManageUsers () {
        let adminControlButton = app.buttons["TabbarAdminControlsButton"]
        XCTAssertTrue(adminControlButton.exists)
        adminControlButton.tap()
        
        
        XCTAssertTrue(app.navigationBars["Admin Controls"].staticTexts["Admin Controls"].exists)
        
        let manageUserButton = app.collectionViews.buttons["Manage Users"]
        let manageRoomsButton = app.collectionViews.buttons["Manage Rooms"]
        
        
        XCTAssertTrue(manageUserButton.exists)
        XCTAssertTrue(manageRoomsButton.exists)
        
        manageUserButton.tap()
        
        
        
    }
    
    
}
