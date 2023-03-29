//
//  AuthorizedUsersView.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 23/03/2023.
//

import SwiftUI

struct AuthorizedUsersView: View {
    @EnvironmentObject var roomsModel: RoomsModel
    var roomIndex: Int
    
    var sampleUsers = ["User 1", "User 2", "User 3"]
    
    @State private var isShowingAllUsers = false
    
    var body: some View{
        List {
            ForEach($roomsModel.rooms[roomIndex].authorizedUsers, id: \.self) { $user in
                Text(user)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Authorized Users")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigation) {
            Button(action: {
                isShowingAllUsers = true
            }) {
                Label("Add User", systemImage: "plus")
            }
            }
        }
        .sheet(isPresented: $isShowingAllUsers) {
            AllUsersView(allUsers: sampleUsers, selectedUsers: $roomsModel.rooms[roomIndex].authorizedUsers)
        }
    }
        
    func delete(at offsets: IndexSet) {
        roomsModel.rooms[roomIndex].authorizedUsers.remove(atOffsets: offsets)
    }
}

struct AuthorizedUsersView_Previews: PreviewProvider {
    
    static var previews: some View {
        Text("hello")
    }
}
