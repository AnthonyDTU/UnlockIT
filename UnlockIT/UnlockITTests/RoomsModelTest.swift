//
//  RoomsModelTest.swift
//  UnlockITTests
//
//  Created by Jonas Stenhold  on 01/05/2023.
//

import XCTest
@testable import UnlockIT

final class RoomsModelClassTest: XCTestCase {
    
    private func generateLocksTestSet(quantity: Int) -> [Lock] {
        var locks: [Lock] = []
        for _ in 1...quantity {
            locks.append(Lock())
        }
        
        return locks
    }
    
    private func generateUsersTestSet(quantity: Int) -> [String] {
        var users: [String] = []
        for _ in 1...quantity {
            users.append("Test User")
        }
        
        return users
    }
    
    private func generateRoomsTestSet() -> [Room] {
        
        var rooms: [Room] = []
        
        for index in 1...4 {
            let room = Room(
                locks: generateLocksTestSet(quantity: index),
                authorizedUsers: generateUsersTestSet(quantity: index),
                bookable: index % 2 == 0
                )
            rooms.append(room)
        }
        
        return rooms
    }
    
    func testRoomsModel() throws {
        var rooms = generateRoomsTestSet()
        
        XCTAssertEqual(rooms[0].locks.count, 1)
        XCTAssertEqual(rooms[1].locks.count, 2)
        XCTAssertEqual(rooms[2].locks.count, 3)
        XCTAssertEqual(rooms[3].locks.count, 4)
        
        XCTAssertEqual(rooms[0].authorizedUsers.count, 1)
        XCTAssertEqual(rooms[1].authorizedUsers.count, 2)
        XCTAssertEqual(rooms[2].authorizedUsers.count, 3)
        XCTAssertEqual(rooms[3].authorizedUsers.count, 4)
        
        XCTAssertTrue(rooms[1].bookable)
        XCTAssertTrue(rooms[3].bookable)
        XCTAssertFalse(rooms[0].bookable)
        XCTAssertFalse(rooms[2].bookable)
    }
}
