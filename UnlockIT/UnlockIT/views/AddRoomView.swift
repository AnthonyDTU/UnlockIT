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
                TextField("Room Description", text: $room.description)
                Picker("Room Type", selection: $room.roomType) {
                    ForEach(RoomType.allCases, id: \.self) { type in
                        Text(type.Description).tag(type)
                    }
                }
            }
            Button("Save") {
                Task {
                    await roomsModel.addRoom(company: user.company, room: room)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Add Room")
        .onDisappear() {
            Task {
                await roomsModel.fetchRooms(company: user.company)
            }
            
        }
    }
}



//struct AddRoomView1_Previews: PreviewProvider {
//    static var previews: some View {
//    }
//}
