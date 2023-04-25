//
//  ContentView.swift
//  firestore-demo
//
//  Created by Jonas Stenhold  on 12/03/2023.
//

import SwiftUI

struct RoomsView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    @EnvironmentObject var user : User
    @State var newRoomIndex: Int? = 1
    @State private var isShowingAddRoomView = false
    
    var body: some View {
            List(RoomType.allCases, id: \.self) { roomType in
                Section(roomType.self.Description) {
                    ForEach(roomsModel.getRoomsByType(type: roomType)) { room in
                        NavigationLink(room.description) {
                            if let roomIndex = roomsModel.rooms.firstIndex(where: { $0.id == room.id }) {
                                RoomView(roomIndex: roomIndex, isEditing: true)
                            }
                        }
                    }
                }
            }
            .onAppear() {
                Task {
                    await roomsModel.fetchRooms(company: user.company)
                }
            }
            .navigationBarTitle(String(localized: "Manage Rooms", comment: "Navigation title for RoomsView"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddRoomView = true
                    }) {
                        Label {
                            Text("Add Room", comment: "Text on button, which navigaties to AddRoomView")
                        } icon: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddRoomView) {
                AddRoomView(room: Room())
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var roomsDummyData = RoomsModel()
    
    
    static var previews: some View {
//              RoomsView(roomsModel: RoomsModel())
            RoomsView()
            .environmentObject(roomsDummyData)
        
    }
}
