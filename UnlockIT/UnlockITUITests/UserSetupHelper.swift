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
        app.launchEnvironment["ADMIN_STATUS"] = "TRUE"
        app.launchEnvironment["FIRST_LOGIN"] = "FALSE"
        app.launchEnvironment["IS_LOGGED_IN"] = "TRUE"
        app.launchEnvironment["IS_VALIDATED"] = "TRUE"
    }
    
    func configureUserAdminStatus(isAdmin: String) {
        app.launchEnvironment["ADMIN_STATUS"] = isAdmin
    }

    func configureFirstLoginStatus(isFirstLogin: String) {
        app.launchEnvironment["FIRST_LOGIN"] = isFirstLogin
    }
    
    func configureIsLoggedIn(isLoggedIn: String) {
        app.launchEnvironment["IS_LOGGED_IN"] = isLoggedIn
    }
    
    func configureIsValidated(isValidated: String) {
        app.launchEnvironment["IS_VALIDATED"] = isValidated
    }
}

