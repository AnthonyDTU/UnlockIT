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
    
    
    func testLoginWithValidCredentials() throws {
        // UI tests must launch the application that they test.
        userSetupHelper!.configureIsLoggedIn(isLoggedIn: "FALSE")
        app.launch()
        
        let goToLoginPageButton = app.buttons["GoToLoginPageButton"]
        XCTAssertTrue(goToLoginPageButton.exists)
        goToLoginPageButton.tap()
        
        //let collectionViewsQuery = XCUIApplication().collectionViews
        let emailTextField = app/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".cells.textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let passwordSecureTextField = app/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("testuser@email.com")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Password123")
        
        let loginButton = app.buttons["PerformLoginButton"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
        XCTAssertTrue(app.images["HomeScreenUnlockITLogo"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.images["HomeScreenUnlockITLogo"].exists)
    }
    
    
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
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("wrongEmail")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("wrongPassword")
        
        let loginButton = app.buttons["PerformLoginButton"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
        XCTAssertTrue(app.alerts["Unexpected Error"].scrollViews.otherElements.buttons["OK"].exists)

    }
}
