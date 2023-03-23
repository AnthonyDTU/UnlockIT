//
//  RoomsModel.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 27/02/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ExampleProtocol {
    var Description: String { get }
}

enum RoomType: String, CaseIterable, Codable {
    
    
    var Description: String {
        return self.getDescription()
    }
    
    func getDescription() -> String {
        switch self {
        case .Meeting:
            return "Meeting"
        case .Silent:
            return "Silent"
        case .Cafeteria:
            return "Cafeteria"
        case .Office:
            return "Office"
        }
    }
    
    case Meeting = "Meeting", Silent = "Silent", Cafeteria = "Cafeteria", Office = "Office"
}

struct Room: Identifiable, Codable, Equatable  {
    
    static var jonasUser = (User(userID: "1", employeeNumber: 25, username: "Jonas", email: "Jensen", department: "Engineering", companyPosition: "Student engineer", privilege: 2, isAdmin: false))
    static var spiderManUser = (User(userID: "2", employeeNumber: 26, username: "Spider", email: "Man", department: "Operations", companyPosition: "Shopper", privilege: 2, isAdmin: false))
    
    static var lock1 = Lock(description: "Lock 1", authenticationLevel: 2, lastUnlock: NSDate(timeIntervalSinceNow: -1000000) as Date)
    static var lock2 = Lock(description: "Lock 2", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -1098664) as Date)
    
    @DocumentID var docId: String?
    var id: UUID = UUID()
    var locks : [Lock] = [];
    var newLock : Lock = Lock()
    var description : String = "Room Description";
    var authorizedUsers : [String] = [jonasUser.username, spiderManUser.username];
    var roomType: RoomType = RoomType.Office;
    var bookable: Bool = true;
    
}

@MainActor
class RoomsModel : ObservableObject, Identifiable {
    @Published var rooms : [Room] = []
    @Published var newRoom: Room = Room()
    
    private lazy var firestore = Firestore.firestore()
    
    
    func updateRoomF(room: Room) {
        let doc = firestore.collection("rooms").document(room.docId!)
        do {
            try doc.setData(from: room)
        }
        catch {
            print(error)
        }
    }
    
    
    func fetchRooms() {
        Task {
            do {
                let collectionSnapShot = try await
                self.firestore.collection("rooms").getDocuments()
                rooms = try collectionSnapShot.documents.compactMap { document in
                    let room = try document.data(as: Room.self)
                    print (room.roomType)
                    print("hello")
                    return room
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    
    
    func addRoom(room: Room) {
        do {
            try firestore.collection("rooms").addDocument(from: room) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                }
                else {
                    print("Document saved successfully")
                }
            }
        }
        catch {
            print("Error printing document: \(error)")
        }
        
    }
    
    func updateRoom(_ room: Room) {
            if let index = rooms.firstIndex(where: { $0.id == room.id }) {
                rooms[index] = room
        }
    }
    
    func getRoomsByType(type: RoomType) -> [Room] {
            return rooms.filter { $0.roomType == type }
        }
    
    init() {
        testData()
    }
    
    func testData() {
        
        let jonasUser = (User(userID: "1", employeeNumber: 2, username: "Jonas", email: "Jensen", department: "Engineering", companyPosition: "Student engineer", privilege: 2, isAdmin: false))
        let spiderManUser = (User(userID: "2",employeeNumber: 3, username: "Spider", email: "Man", department: "Operations", companyPosition: "Shopper", privilege: 2, isAdmin: false))
        let barackUser = (User(userID: "3", employeeNumber: 4, username: "Barack", email: "Obama", department: "Secretariat", companyPosition: "Secretary", privilege: 2, isAdmin: false))
        let billUser = (User(userID: "4", employeeNumber: 5, username: "Bill", email: "Clinton", department: "Sales", companyPosition: "Sales Manager", privilege: 3, isAdmin: false))
        let oprahUser = (User(userID: "5", employeeNumber: 6, username: "Oprah", email: "Something", department: "Sales", companyPosition: "Sales Woman", privilege: 2, isAdmin: false))
        let elonUser = (User(userID: "6", employeeNumber: 7, username: "Elon", email: "Musk", department: "Engineering", companyPosition: "Engineering Manager", privilege: 3, isAdmin: false))
        
        var roomStructs: [Room] = []
        var lockStructs1: [Lock] = []
        var lockStructs2: [Lock] = []
        var lockStructs3: [Lock] = []
        var lockStructs4: [Lock] = []
        var lockStructs5: [Lock] = []
        var lockStructs6: [Lock] = []
        
        
        lockStructs1.append(Lock(description: "Lock 1", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -10000) as Date))
        lockStructs1.append(Lock(description: "Lock 1", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -15000) as Date))
        
        lockStructs2.append(Lock(description: "Lock 1", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -20000) as Date))
        lockStructs2.append(Lock(description: "Lock 1", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -25000) as Date))
        
        lockStructs3.append(Lock(description: "Lock 1", authenticationLevel: 1, lastUnlock: NSDate(timeIntervalSinceNow: -22500) as Date))
        
        lockStructs4.append(Lock(description: "Lock 1", authenticationLevel: 2, lastUnlock: NSDate(timeIntervalSinceNow: -23000) as Date))
        
        lockStructs5.append(Lock(description: "Lock 1", authenticationLevel: 2, lastUnlock: NSDate(timeIntervalSinceNow: -700000) as Date))
        
        lockStructs6.append(Lock(description: "Lock 1", authenticationLevel: 3, lastUnlock: NSDate(timeIntervalSinceNow: -50000) as Date))
        
        roomStructs.append(Room(
            locks: lockStructs1,
            description: "Sales Office, floor 2",
            authorizedUsers: [barackUser.username, spiderManUser.username],
            roomType: RoomType.Office,
            bookable: false))
        
        roomStructs.append(Room(
            locks: lockStructs2,
            description: "Engineering Office, floor 2",
            authorizedUsers: [oprahUser.username],
            roomType: RoomType.Office,
            bookable: false))
        
        roomStructs.append(Room(
            locks: lockStructs3,
            description: "Cafeteria 1",
            authorizedUsers: [],
            roomType: RoomType.Cafeteria,
            bookable: false))
        
        roomStructs.append(Room(
            locks: lockStructs4,
            description: "Secretariat",
            authorizedUsers: [],
            roomType: RoomType.Office,
            bookable: false))
        
        roomStructs.append(Room(
            locks: lockStructs5,
            description: "Ordinary Meeting Room",
            authorizedUsers: [],
            roomType: RoomType.Meeting,
            bookable: true))
        
        roomStructs.append(Room(
            locks: lockStructs6,
            description: "Managers Meeting Room",
            authorizedUsers: [],
            roomType: RoomType.Meeting,
            bookable: true))
        
        rooms = roomStructs
    }
}
