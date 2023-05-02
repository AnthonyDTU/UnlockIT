//
//  UserClassTest.swift
//  UnlockITTests
//
//  Created by Anton Lage on 27/03/2023.
//

import XCTest
import LocalAuthentication
@testable import UnlockIT

final class UserClassTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    /// Tests if the user objects is being correctly configured by some sample data
    func testConfigureUserFromData() throws {
        let userID: String = "0000-1111"
        let data: [String : Any]  = [
            "username" : "username",
            "position" : "position",
            "employeeNumber" : 1,
            "company" : "company",
            "department" : "department",
            "privilege" : 5,
            "email" : "email",
            "isAdmin": true,
            "firstLogin": true
        ]
        
        let user = User()
        user.configureUserData(userID: userID, data: data)
        
        XCTAssertEqual(user.userID, userID)
        XCTAssertEqual(user.username, "username")
        XCTAssertEqual(user.position, "position")
        XCTAssertEqual(user.employeeNumber, 1)
        XCTAssertEqual(user.company, "company")
        XCTAssertEqual(user.department, "department")
        XCTAssertEqual(user.email, "email")
        XCTAssertEqual(user.isAdmin, true)
        XCTAssertEqual(user.firstLogin, true)
    }
    
    /// Test if the logic in the function for validating users biometricatlly works
    func testValidateUserWithBiometrics() async throws {
        
        class MOCK_LAContext : LAContext {
            override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
                return true
            }
            
            override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String) async throws -> Bool {
                return true
            }
        }
        
        let user = User()
        user.authContext = MOCK_LAContext()
        try await user.validateUser()
        
        let expectation = XCTestExpectation(description: "User has been validated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            //then
            XCTAssertTrue(user.isValidated)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 3.0)
        
    }
}
