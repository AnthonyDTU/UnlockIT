//
//  AddRoomView1.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 29/03/2023.
//

import SwiftUI

struct AddRoomView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    @EnvironmentObject var user: User
    @State var room: Room
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List {
                TextField(String(localized: "Room Description", comment: "Placeholder text for room description textfield"), text: $room.description)
                Picker(String(localized: "Room Type", comment: "Picker text for selecting the type of room in AddRoomView"), selection: $room.roomType) {
                    ForEach(RoomType.allCases, id: \.self) { type in
                        Text(type.Description).tag(type)
                    }
                }
            }
            Button() {
                Task {
                    do {
                        try roomsModel.addRoom(company: user.company, room: room)
                    }
                    catch {
                        print("Faield to add room")
                    }
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save", comment: "Button for saving a new room in AddRoomView")
            }
        }
        .onDisappear() {
            roomsModel.fetchRooms(company: user.company)
        }
    }
}
