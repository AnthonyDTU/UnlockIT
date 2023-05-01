//
//  ChangePasswordOnFirstLoginUITest.swift
//  UnlockITUITests
//
//  Created by Anton Lage on 01/05/2023.
//

import XCTest

final class ChangePasswordOnFirstLoginUITest: XCTestCase {

    let app = XCUIApplication()
    var userSetupHelper: UserSetupHelper? = nil
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI_TESTING"]
        userSetupHelper = UserSetupHelper(app: app)
        userSetupHelper!.configureDefaultUser()
    }
    
    
    func testPasswordMustBeChangedOnFirstLogin() throws {
        // UI tests must launch the application that they test.
        userSetupHelper!.configureFirstLoginStatus(isFirstLogin: "TRUE")
        app.launch()
        
        let goToChangePasswordPageButton = app.buttons["GoToUpdatePasswordScreenButton"]
        XCTAssertTrue(goToChangePasswordPageButton.exists)
        goToChangePasswordPageButton.tap()
        
        //let collectionViewsQuery = XCUIApplication().collectionViews
        let newPasswordSecureTextField = app.secureTextFields["NewPasswordSecureEntry"]
        let confirmNewPasswordSecureTextField = app.secureTextFields["ConfirmNewPasswordSecureEntry"]
        let changePasswordButton = app.buttons["PerformChangePasswordButton"]
        
        XCTAssertTrue(newPasswordSecureTextField.exists)
        XCTAssertTrue(confirmNewPasswordSecureTextField.exists)
        XCTAssertTrue(changePasswordButton.exists)
    }
}
