//
//  UserbaseSetupHelper.swift
//  UnlockITUITests
//
//  Created by Anton Lage on 02/05/2023.
//

import Foundation
import XCTest

class UserbaseSetupHelper {
    
    let app: XCUIApplication
    
    init(app: XCUIApplication, numberOfUsersInUserbase: String) {
        self.app = app
        self.app.launchEnvironment["NUMBER_OF_USERS_IN_USERBASE"] = numberOfUsersInUserbase
    }
}
