//
//  RoomsView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 27/02/2023.
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
                            RoomView(room: room)
                        }
                    }
                }
            }
        }
    }
}

struct RoomsView_Previews: PreviewProvider {
    static let roomsDummyData = RoomsModel()
    static var previews: some View {
        RoomsView().environmentObject(roomsDummyData)
    }
}
