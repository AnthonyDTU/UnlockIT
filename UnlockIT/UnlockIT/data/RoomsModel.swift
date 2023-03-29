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
        case .Other:
            return "Other"
        }
    }
    
    case Meeting = "Meeting", Silent = "Silent", Cafeteria = "Cafeteria", Office = "Office",
    Other = "Other"
}

struct Room: Identifiable, Codable, Equatable  {
    @DocumentID var docId: String?
    var id: UUID = UUID()
    var locks : [Lock] = [];
    var newLock : Lock = Lock()
    var description : String = "Room Description";
    var authorizedUsers : [String] = [];
    var roomType : RoomType = .Meeting
    var bookable: Bool = true;
    
}

@MainActor
class RoomsModel : ObservableObject, Identifiable {
    @Published var rooms : [Room] = []
    private lazy var firestore = Firestore.firestore()
    
    
    /// returns the `rooms` array
    func fetchRooms(company: String) async {
        Task {
            //TODO - implement error handling (Result {...} switch(result) ...)
            do {
                let collectionSnapShot = try await
                self.firestore.collection("Companies").document(company).collection("Rooms").getDocuments()
                rooms = try collectionSnapShot.documents.compactMap { document in
                    let room = try document.data(as: Room.self)
                    return room
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    /// Add a room to the array of room structs `rooms` in  a `RoomsModel`
    /// - Parameter room: Room to be added
    func addRoom(company: String, room: Room) async {
        do {
            try firestore.collection("Companies").document(company).collection("Rooms").addDocument(from: room) { error in
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
    
    /// Update a room in the array of room structs `rooms` in a `RoomsModel`
    /// - Parameter room: Room to be updated
    func updateRoom(company: String, room: Room) {
        let doc = firestore.collection("Companies").document(company).collection("Rooms").document(room.docId!)
        do {
            try doc.setData(from: room)
        }
        catch {
            print(error)
        }
    }
    
    /// Delete a `room` struct in the array of room structs `rooms` for a given `RoomsModel`
    /// - Parameter room: Room to be deleted
    func deleteRoom(company: String, _ room: Room) {
        try firestore.collection("Companies").document(company).collection("Rooms").document(room.docId!).delete() { error in
            if let error = error {
                print("Error Deleting Room: \(error)")
            }
            else {
                print("Document Deleted Succesfully")
            }
        }
    }
    
    func getRoomsByType(type: RoomType) -> [Room] {
        return rooms.filter { $0.roomType == type }
    }
}
