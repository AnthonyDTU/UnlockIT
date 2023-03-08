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
        
        VStack {
            
            List(userbaseModel.users) { user in
                NavigationLink {
                    TestView()
                } label: {
                    Label(user.username, systemImage: "person.badge.plus")
                }
                //Text(user.username)
            }
            
            //Text("Hello Anton!")
            //Text("Number of users: \(userbaseModel.users.count)")
        }
        .navigationBarTitle("Manage Users")
        .onAppear(){
            userbaseModel.loadExistingUsers()
        }
        .refreshable {
            //userbaseModel.loadExistingUsers()
        }
    }
}

struct ManageUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageUsersView()
    }
}
