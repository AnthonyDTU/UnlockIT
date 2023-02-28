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
        
        let jonasUser = (User(id: "1", name: "Jonas", email: "Jensen", department: "Engineering", companyPosition: "Student engineer", password: "pwd", privilege: 2, isAdmin: false))
        let spiderManUser = (User(id: "2", name: "Spider", email: "Man", department: "Operations", companyPosition: "Shopper", password: "pwd", privilege: 2, isAdmin: false))
        let barackUser = (User(id: "3", name: "Barack", email: "Obama", department: "Secretariat", companyPosition: "Secretary", password: "pwd", privilege: 2, isAdmin: false))
        let billUser = (User(id: "4", name: "Bill", email: "Clinton", department: "Sales", companyPosition: "Sales Manager", password: "pwd", privilege: 3, isAdmin: false))
        let oprahUser = (User(id: "5", name: "Oprah", email: "Something", department: "Sales", companyPosition: "Sales Woman", password: "pwd", privilege: 2, isAdmin: false))
        let elonUser = (User(id: "6", name: "Elon", email: "Musk", department: "Engineering", companyPosition: "Engineering Manager", password: "pwd", privilege: 3, isAdmin: false))
        
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
            authorizedUsers: [barackUser, spiderManUser],
            roomType: RoomType.office,
            bookable: false))
        
        roomStructs.append(Room(
            id: "2",
            locks: lockStructs2,
            description: "Engineering Office, floor 2",
            authorizedUsers: [oprahUser],
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
