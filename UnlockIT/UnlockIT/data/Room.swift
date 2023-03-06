//
//  Room.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 27/02/2023.
//

import Foundation

protocol ExampleProtocol {
    var Description: String { get }
}

enum RoomType: CaseIterable, ExampleProtocol {
    
    
    var Description: String {
        return self.getDescription()
    }
    
    func getDescription() -> String {
        switch self {
        case .meeting:
            return "Meeting"
        case .silent:
            return "Silent"
        case .cafeteria:
            return "Cafeteria"
        case .office:
            return "Office"
        }
    }
    
    case meeting, silent, cafeteria, office
}

struct Room: Identifiable  {
    
    static let jonasUser = (User(id: "1", employeeNumber: 25, username: "Jonas", email: "Jensen", department: "Engineering", companyPosition: "Student engineer", privilege: 2, isAdmin: false))
    static let spiderManUser = (User(id: "2", employeeNumber: 26, username: "Spider", email: "Man", department: "Operations", companyPosition: "Shopper", privilege: 2, isAdmin: false))
    
    static let lock1 = Lock(id: "1", authenticationLevel: 2, lastUnlock: NSDate(timeIntervalSinceNow: -1000000))
    static let lock2 = Lock(id: "2", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -1098664))
    
    var id: String = "2"
    var locks : [Lock] = [lock1, lock2];
    var description : String = "Random Room";
    var authorizedUsers : [User] = [jonasUser, spiderManUser];
    var roomType: RoomType = RoomType.office;
    var bookable: Bool = true;
    
    
//    init(id: String, locks: [Lock], description: String, authorizedUsers: [User], roomType: RoomType, bookable: Bool) {
//        self.id = id
//        self.locks = locks
//        self.description = description
//        self.authorizedUsers = authorizedUsers
//        self.roomType = roomType
//        self.bookable = bookable
//    }
    
    
    
}
