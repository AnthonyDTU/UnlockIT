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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testAdminControlsAvaliableForAdmin() throws {
        // UI tests must launch the application that they test.
        
        userSetupHelper!.configureUserAdminStatus(isAdmin: "TRUE")
        app.launch()
        let adminButtonText = app.staticTexts["adminControlTabBarButtonLabel"]
        XCTAssertTrue(adminButtonText.exists, "Admin button is missing")
        XCTAssertEqual(adminButtonText.label, "Admin Controls", "label is not correct")
    }
    
    
    func testAdminControlsNotAvaliableForNonAdmin() throws {
        userSetupHelper!.configureUserAdminStatus(isAdmin: "FALSE")
        app.launch()
        let adminButtonText = app.staticTexts["adminControlTabBarButtonLabel"]
        XCTAssertFalse(adminButtonText.exists, "Admin button is visible for non admin")
    }
}
