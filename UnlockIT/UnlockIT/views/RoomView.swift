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
            
            Section(String(localized: "Room Description", comment: "Section title for RoomDescription in RoomView")) {
                TextField(String(localized: "Description", comment: "Placeholder for Description text field"), text: $roomsModel.rooms[roomIndex].description)
                Picker(String(localized: "Room Type", comment: "Text on picker item in RoomView"), selection: $roomsModel.rooms[roomIndex].roomType) {
                    ForEach(RoomType.allCases, id: \.self) { type in
                        Text(type.Description).tag(type)
                    }
                }
            }
            
            Section(String(localized: "Authorization", comment: "Section title for Authorization in RoomView")) {
                NavigationLink() {
                    AuthorizedUsersView(roomIndex: roomIndex)
                } label: {
                    Text("Authorized Users", comment: "Text on navigation link, navigating to Authorized Users View")
                }
                
                NavigationLink() {
                    LocksView(roomIndex: roomIndex)
                } label: {
                    Text("Locks", comment: "Navigation Link to LocksView")
                }
            }
            
            Section(String(localized: "Attributes", comment: "Section title for Attributes in RoomView")) {
                Toggle(String(localized: "Bookable", comment: "Text on toggle item"), isOn: $roomsModel.rooms[roomIndex].bookable)
            }
            
            if (isEditing) {
                Button() {
                    roomsModel.updateRoom(company: user.company, room: $roomsModel.rooms[roomIndex].wrappedValue)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Update room", comment: "Text on button, which updates an edited room")
                }
            }
            else {
                Button() {
                    Task {
                        await roomsModel.fetchRooms(company: user.company)
                        didAddRoom = true
                    }
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Add room", comment: "Text on button, which adds a room")
                }
            }
            
            Button() {
                roomsModel.deleteRoom(company: user.company, roomsModel.rooms[roomIndex])
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Delete", comment: "Text on button, which adds a room")
            }
        }
        .navigationTitle(String(localized: "Room", comment: "Navigation title for RoomView"))
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
