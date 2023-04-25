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
        .navigationTitle(String(localized: "Authorized Users", comment: "Navigation title for AuthorizedUsersView"))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    isShowingAllUsers = true
                }) {
                    Label {
                        Text("Add User", comment: "Text on button, which navigaties to AllUsersView")
                    } icon: {
                        Image(systemName: "plus")
                    }
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
