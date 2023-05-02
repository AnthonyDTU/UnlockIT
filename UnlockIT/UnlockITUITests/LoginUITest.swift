//
//  LoginUITest.swift
//  UnlockITUITests
//
//  Created by Anton Lage on 01/05/2023.
//

import XCTest

final class LoginUITest: XCTestCase {

    let app = XCUIApplication()
    var userSetupHelper: UserSetupHelper? = nil
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI_TESTING"]
        userSetupHelper = UserSetupHelper(app: app)
        userSetupHelper!.configureDefaultUser()
    }
    
    
    func testLoggedOutStateUI() throws {
        // UI tests must launch the application that they test.
        userSetupHelper!.configureIsLoggedIn(isLoggedIn: "FALSE")
        app.launch()
        
        let goToLoginPageButton = app.buttons["GoToLoginPageButton"]
        XCTAssertTrue(goToLoginPageButton.exists)
        goToLoginPageButton.tap()
        
        //let collectionViewsQuery = XCUIApplication().collectionViews
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let loginButton = app.buttons["PerformLoginButton"]
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        XCTAssertTrue(loginButton.exists)
        
        /*
        emailTextField.tap()
        emailTextField.typeText("testuser@email.com")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Password123")
        
        loginButton.tap()
        
        XCTAssertTrue(app.images["HomeScreenUnlockITLogo"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.images["HomeScreenUnlockITLogo"].exists)
         */
    }
    
    /*
    func testLoginWithInvlaidCredentials() throws {
        // UI tests must launch the application that they test.
        userSetupHelper!.configureIsLoggedIn(isLoggedIn: "FALSE")
        app.launch()
        
        let goToLoginPageButton = app.buttons["GoToLoginPageButton"]
        XCTAssertTrue(goToLoginPageButton.exists)
        goToLoginPageButton.tap()
        
        
        //let collectionViewsQuery = XCUIApplication().collectionViews
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let loginButton = app.buttons["PerformLoginButton"]
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        XCTAssertTrue(loginButton.exists)
        
        /*
        emailTextField.tap()
        emailTextField.typeText("wrongEmail")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("wrongPassword")
        loginButton.tap()
        
        XCTAssertTrue(app.alerts["Unexpected Error"].scrollViews.otherElements.buttons["OK"].exists)
        */
    }
    */
}
