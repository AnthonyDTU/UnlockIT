//
//  UsermodelClassTest.swift
//  UnlockITTests
//
//  Created by Anton Lage on 28/03/2023.
//

import XCTest
@testable import UnlockIT

final class UsermodelClassTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func generateUserTestSet() -> [User] {
        
        var users: [User] = []
        
        for index in 1...4 {
            let user = User()
            user.configureUserData(userID: String(index), data: [
                "username" : String("user \(index)"),
                "employeeNumber" : index,
                "email" : String("user\(index)@test.com"),
                "company" : "testCompany",
                "department" : "UnitTesting",
                "position" : "tester",
                "privilege" : index,
                "isAdmin" : index % 2 == 0,
                "firstLogin" : index % 2 != 0
            ])
            
            users.append(user)
        }
        return users
    }
    
    func testGetAdminUsers() throws {
        
        let userbase = UserbaseViewModel()
        userbase.users = generateUserTestSet()
        
        let adminUsers = userbase.getAdministrators()
        XCTAssertEqual(adminUsers.count, 2)
        XCTAssertTrue(adminUsers[0].isAdmin)
        XCTAssertTrue(adminUsers[1].isAdmin)
    }
    
    func testGetNonAdminUsers() throws {
        
        let userbase = UserbaseViewModel()
        userbase.users = generateUserTestSet()
        
        let nonAdminUsers = userbase.getNonAdministrators()
        XCTAssertEqual(nonAdminUsers.count, 2)
        XCTAssertFalse(nonAdminUsers[0].isAdmin)
        XCTAssertFalse(nonAdminUsers[1].isAdmin)
    }
    
    


}
