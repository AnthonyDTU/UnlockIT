//
//  ManageUsers.swift
//  UnlockIT
//
//  Created by Anton Lage on 06/03/2023.
//

import SwiftUI

struct ManageUsersView: View {
    
    @StateObject private var userbaseModel = UserbaseViewModel()
    
    var body: some View {
        List(userbaseModel.users) { user in
            NavigationLink{
                TestView()
            } label: {
                Text(user.username)
            }
        }
        .navigationBarTitle("Manage Users")
        .onAppear(){
            userbaseModel.loadExistingUsers()
            //userbaseModel.listenToUserDatabase()
        }
        onDisappear(){
            //userbaseModel.stopListening()
        }
    }
}

struct ManageUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageUsersView()
    }
}
