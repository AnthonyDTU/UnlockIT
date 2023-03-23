//
//  ContentView.swift
//  firestore-demo
//
//  Created by Jonas Stenhold  on 12/03/2023.
//

import SwiftUI

struct RoomsView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    
    
    var body: some View {
        NavigationStack {
            List(RoomType.allCases, id: \.self) { roomType in
                Section(roomType.self.Description) {
                    ForEach(roomsModel.getRoomsByType(type: roomType)) { room in
                        NavigationLink(room.description) {
                            if let roomIndex = roomsModel.rooms.firstIndex(where: { $0.id == room.id }) {
                                        RoomView(room: $roomsModel.rooms[roomIndex])
                            }
                        }
                    }
                }
            }
//            List(RoomType.allCases, id: \.self) { roomType in
//                ForEach(roomsModel.getRoomsByType(type: roomType)) { room in
//                    Text("\(room.description)")
//                }
//            }
            NavigationLink(destination: AddRoomView(room: $roomsModel.newRoom, isEditing: false)) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add a room")
                }
            }
            .onTapGesture {
                let newRoom = Room()
                roomsModel.newRoom = newRoom
            }
        }
        .onAppear() {
            roomsModel.fetchRooms()
        }
        .navigationBarTitle("Manage Rooms")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var roomsDummyData = RoomsModel()
    
    
    static var previews: some View {
        
            RoomsView()
            .environmentObject(roomsDummyData)
        
    }
}
