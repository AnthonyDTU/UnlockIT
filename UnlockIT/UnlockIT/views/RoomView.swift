//
//  RoomView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 28/02/2023.
//

import SwiftUI

struct RoomView: View {
    
    @Binding var room: Room
    
    
    var body: some View {
        ScrollView {
            VStack {
                HStack{
                    Text(room.description)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                Divider().background(Color.blue)
                Text("Assigned Locks    \(Image(systemName: "list.bullet"))").font(.title3).padding().fontWeight(.semibold)
                Divider().background(Color.blue)
                VStack {
                    ForEach(room.locks) { lock in
                        VStack {
                            HStack{
                                Text("Lock")
                                Text(Image(systemName: "lock"))
                            }
                            HStack {
                                Text("Authentication Level: ")
                                Spacer()
                                Text("\(lock.authenticationLevel)").bold()
                            }
                            .padding()
                            
                            DatePicker (
                                "Last Unlocked",
                                selection: .constant(lock.lastUnlock as Date),
                                displayedComponents: [.date, .hourAndMinute]
                            ).font(.headline)
                                .foregroundColor(.blue)
                                .disabled(true)
                            .padding()
                        }
                        Divider()
                            .padding(.horizontal, 20)
                    }
                    
                    
                }
                Divider().background(Color.blue).frame(height: 20)
                Text("Authorized Users    \(Image(systemName: "list.bullet"))").font(.title3).padding().fontWeight(.semibold)
                Divider().background(Color.blue)
                
                ForEach(room.authorizedUsers, id: \.self) { user in
                    HStack {
                        Text(Image(systemName: "person.circle"))
                        Text("\(user)")
                    }
                    .padding(2)
                }
                .background(Color.white)
                
                NavigationLink("Edit", destination: AddRoomView(room: $room, isEditing: true))
                
                //Spacer()
            }
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var roomsDummyData = RoomsModel()
    static var room = Binding<Room>(get: { roomsDummyData.newRoom }, set: { roomsDummyData.newRoom = $0 })
    
    
    
    static var previews: some View {
        
        RoomView(room: room)
    }
}
