//
//  RoomView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 28/02/2023.
//

import SwiftUI

struct RoomView: View {
    
    var room: Room
    
    init(room: Room) {
        self.room = room
    }
    
    var body: some View {
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
            Divider().background(Color.blue)
            Text("Authorized Users    \(Image(systemName: "list.bullet"))").font(.title3).padding().fontWeight(.semibold)
            Divider().background(Color.blue)
            
            List(room.authorizedUsers){
                Text($0.name)
            }
            .background(Color.white)
            
            Spacer()
        }
        
    }
}

struct RoomView_Previews: PreviewProvider {
    static let room = Room()
    
    
    
    static var previews: some View {
        
        RoomView(room: room)
    }
}
