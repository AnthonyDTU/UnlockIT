//
//  RoomsModel.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 27/02/2023.
//

import Foundation

class RoomsModel : ObservableObject, Identifiable {
    @Published var rooms : [Room] = []
    var id = UUID().uuidString
    
    func getRoomsByType(type: RoomType) -> [Room] {
        return rooms.filter { $0.roomType == type}
    }
    
    init() {
        testData()
    }
    
    func testData() {
        /*
        let jonasUser = (User(userID: "1", employeeNumber: 2, username: "Jonas", email: "Jensen", department: "Engineering", companyPosition: "Student engineer", privilege: 2, isAdmin: false, isFirstLogin: false))
        let spiderManUser = (User(userID: "2",employeeNumber: 3, username: "Spider", email: "Man", department: "Operations", companyPosition: "Shopper", privilege: 2, isAdmin: false, isFirstLogin: false))
        let barackUser = (User(userID: "3", employeeNumber: 4, username: "Barack", email: "Obama", department: "Secretariat", companyPosition: "Secretary", privilege: 2, isAdmin: false, isFirstLogin: false))
        let billUser = (User(userID: "4", employeeNumber: 5, username: "Bill", email: "Clinton", department: "Sales", companyPosition: "Sales Manager", privilege: 3, isAdmin: false, isFirstLogin: false))
        let oprahUser = (User(userID: "5", employeeNumber: 6, username: "Oprah", email: "Something", department: "Sales", companyPosition: "Sales Woman", privilege: 2, isAdmin: false, isFirstLogin: false))
        let elonUser = (User(userID: "6", employeeNumber: 7, username: "Elon", email: "Musk", department: "Engineering", companyPosition: "Engineering Manager", privilege: 3, isAdmin: false, isFirstLogin: false))
        */
        var roomStructs: [Room] = []
        var lockStructs1: [Lock] = []
        var lockStructs2: [Lock] = []
        var lockStructs3: [Lock] = []
        var lockStructs4: [Lock] = []
        var lockStructs5: [Lock] = []
        var lockStructs6: [Lock] = []
        
        
        lockStructs1.append(Lock(id: "10", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -10000)))
        lockStructs1.append(Lock(id: "11", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -15000)))
        
        lockStructs2.append(Lock(id: "12", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -20000)))
        lockStructs2.append(Lock(id: "13", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -25000)))
        
        lockStructs3.append(Lock(id: "14", authenticationLevel: 1, lastUnlock: NSDate(timeIntervalSinceNow: -22500)))
        
        lockStructs4.append(Lock(id: "15", authenticationLevel: 2, lastUnlock: NSDate(timeIntervalSinceNow: -23000)))
        
        lockStructs5.append(Lock(id: "16", authenticationLevel: 2, lastUnlock: NSDate(timeIntervalSinceNow: -700000)))
        
        lockStructs6.append(Lock(id: "17", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -50000)))
        
        roomStructs.append(Room(
            id: "1",
            locks: lockStructs1,
            description: "Sales Office, floor 2",
            authorizedUsers: [],
            roomType: RoomType.office,
            bookable: false))
        
        roomStructs.append(Room(
            id: "2",
            locks: lockStructs2,
            description: "Engineering Office, floor 2",
            authorizedUsers: [],
            roomType: RoomType.office,
            bookable: false))
        
        roomStructs.append(Room(
            id: "3",
            locks: lockStructs3,
            description: "Cafeteria 1",
            authorizedUsers: [],
            roomType: RoomType.cafeteria,
            bookable: false))
        
        roomStructs.append(Room(
            id: "4",
            locks: lockStructs4,
            description: "Secretariat",
            authorizedUsers: [],
            roomType: RoomType.office,
            bookable: false))
        
        roomStructs.append(Room(
            id: "5",
            locks: lockStructs5,
            description: "Ordinary Meeting Room",
            authorizedUsers: [],
            roomType: RoomType.meeting,
            bookable: true))
        
        roomStructs.append(Room(
            id: "6",
            locks: lockStructs6,
            description: "Managers Meeting Room",
            authorizedUsers: [],
            roomType: RoomType.meeting,
            bookable: true))
        
        rooms = roomStructs
    }
}
