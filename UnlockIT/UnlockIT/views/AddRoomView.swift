//
//  AddRoomView.swift
//  firestore-demo
//
//  Created by Jonas Stenhold  on 12/03/2023.
//

import SwiftUI

struct AddRoomView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    @Binding var room: Room
    var isEditing: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    //TODO - fetch all user from database
    let options = ["User 1", "User 2", "User 3"]
    
    
    var body: some View {
        Form {
            Section("Room Description") {
                TextField("Description", text: $room.description)
                Picker("Room Type", selection: $room.roomType) {
                    ForEach(RoomType.allCases, id: \.self) { type in
                        Text(type.getDescription()).tag(type)
                    }
                }
            }
            Section("Authorization") {
                    MultiSelectComboBox(description: "Authorized Users", options: options, selectedOptions: $room.authorizedUsers)
            }
            NavigationLink("Attach A Lock", destination: AddLockView(locks: $room.locks))
            Section("Locks") {
                //TODO - this probaly needs to change ..
                List($room.locks) { $lock in
                    Text("\(lock.description)");
                }
            }
            Section("Attributes") {
                Toggle("Bookable?", isOn: $room.bookable)
            }
            if (isEditing) {
                Button("Update room") {
                    roomsModel.updateRoomF(room: self.room)
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
            else {
                Button("Add room") {
                    roomsModel.rooms.append(room)
                    roomsModel.addRoom(room: room)
                    roomsModel.fetchRooms()
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct AddRoomView_Previews: PreviewProvider {
    static var roomsDummyData = RoomsModel()
        static var room = Binding<Room>(get: { roomsDummyData.newRoom }, set: { roomsDummyData.newRoom = $0 })
           
        static var previews: some View {
            AddRoomView(room: room, isEditing: false).environmentObject(roomsDummyData)
        }
}
