//
//  KeychainManagerTests.swift
//  UnlockITTests
//
//  Created by Anton Lage on 02/05/2023.
//

import XCTest
@testable import UnlockIT

final class KeychainManagerTests: XCTestCase {

    func testStoreAndFecthInKeychain() throws {
        
        let testKey = "testKey"
        let testString = "test data"
        
        let keychainManager = KeychainManager()
        try keychainManager.storeValue(key: testKey, data: testString.data(using: .utf8)!)
        
        let loadedData = try keychainManager.fetchValue(key: testKey)
        XCTAssertNotNil(loadedData)
        
        let loadedString = String(decoding: loadedData!, as: UTF8.self)
        XCTAssertEqual(testString, loadedString)
    }
}
