//
//  UserSetupHelper.swift
//  UnlockITUITests
//
//  Created by Anton Lage on 28/04/2023.
//

import Foundation
import XCTest

class UserSetupHelper {
    
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func configureDefaultUser() {
        app.launchEnvironment.updateValue("TRUE", forKey: "ADMIN_STATUS")
        app.launchEnvironment.updateValue("FALSE", forKey: "FIRST_LOGIN")
        app.launchEnvironment.updateValue("TRUE", forKey: "IS_LOGGED_IN")
        app.launchEnvironment.updateValue("TRUE", forKey: "IS_VALIDATED")
    }
    
    func configureUserAdminStatus(isAdmin: String) {
        app.launchEnvironment.updateValue(isAdmin, forKey: "ADMIN_STATUS")
    }

    func configureFirstLoginStatus(isFirstLogin: String) {
        app.launchEnvironment.updateValue(isFirstLogin, forKey: "FIRST_LOGIN")
    }
    
    func configureIsLoggedIn(isLoggedIn: String) {
        app.launchEnvironment.updateValue("TRUE", forKey: "IS_LOGGED_IN")
    }
    
    func configureIsValidated(isValidated: String) {
        app.launchEnvironment.updateValue(isValidated, forKey: "IS_VALIDATED")
    }
}

