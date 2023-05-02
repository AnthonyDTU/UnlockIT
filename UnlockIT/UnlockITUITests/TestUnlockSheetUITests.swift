//
//  TestUnlockSheetUITests.swift
//  UnlockITUITests
//
//  Created by Anton Lage on 02/05/2023.
//

import XCTest

final class TestUnlockSheetUITests: XCTestCase {
    let app = XCUIApplication()
    var userSetupHelper: UserSetupHelper? = nil
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI_TESTING"]
        userSetupHelper = UserSetupHelper(app: app)
        userSetupHelper!.configureDefaultUser()
        
    }

    func testUnlockSheetUI() throws {
        // UI tests must launch the application that they test.
        app.launch()
        
        let homeScreenInlockITLogoImage = app.images["HomeScreenUnlockITLogo"]
        XCTAssertTrue(homeScreenInlockITLogoImage.exists)
        homeScreenInlockITLogoImage.tap()

        XCTAssertTrue(app.staticTexts["NFC Simulator"].exists)
        XCTAssertTrue(app.images["iphone.gen2.radiowaves.left.and.right"].exists)
        XCTAssertTrue(app.buttons["Cancel"].exists)
        XCTAssertTrue(app.images["HomeScreenUnlockITLogo"].exists)
        XCTAssertTrue(app.buttons["Unlock"].exists)
    }
}
