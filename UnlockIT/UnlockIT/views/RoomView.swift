//
//  AddRoomView.swift
//  firestore-demo
//
//  Created by Jonas Stenhold  on 12/03/2023.
//

import SwiftUI

struct RoomView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    @EnvironmentObject var user: User
    var roomIndex: Int
    var isEditing: Bool
    @State private var didAddRoom = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var options: [User] = [
        User(name: "Jonas"),
        User(name: "Sarah"),
        User(name: "Jens")
    ]
    
    @State private var multiSelection = Set<User>()
    
    var body: some View {
        
        Form {
            Section("Room Description") {
                TextField("Description", text: $roomsModel.rooms[roomIndex].description)
                Picker("Room Type", selection: $roomsModel.rooms[roomIndex].roomType) {
                    ForEach(RoomType.allCases, id: \.self) { type in
                        Text(type.Description).tag(type)
                    }
                }
            }
            Section("Authorization") {
                NavigationLink(destination: AuthorizedUsersView(roomIndex: roomIndex)) {
                    Text("Authorized Users")
                }
                NavigationLink("Locks") {
                    LocksView(roomIndex: roomIndex)
                }
            }
            Section("Attributes") {
                Toggle("Bookable", isOn: $roomsModel.rooms[roomIndex].bookable)
            }
            if (isEditing) {
                Button("Update room") {
                    roomsModel.updateRoom(company: user.company, room: $roomsModel.rooms[roomIndex].wrappedValue)
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
            else {
                Button("Add room") {
                    Task {
                        await roomsModel.fetchRooms(company: user.company)
                        didAddRoom = true
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button("Delete") {
                roomsModel.deleteRoom(company: user.company, roomsModel.rooms[roomIndex])
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Room")
        .onAppear() {
            print("Index in Add Room view: \(roomIndex)")
        }
        .onDisappear() {
            if (!didAddRoom && !isEditing) {
                roomsModel.rooms.remove(at: roomIndex)
            }
        }
        
        
    }
}

//struct RoomView_Previews: PreviewProvider {
//        static var previews: some View {
//        }
//}
