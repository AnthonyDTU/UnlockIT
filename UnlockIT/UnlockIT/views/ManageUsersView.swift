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
        
        List {
            ForEach(userbaseModel.users, id: \.self) { user in
                NavigationLink {
                    EditUserView(user: $userbaseModel.users[userbaseModel.users.firstIndex(of: user) ?? 0])
                } label: {
                    Label(user.username, systemImage: "person")
                }
            }
            VStack {
                HStack{
                    Spacer()
                    Text("Total number of users: \(userbaseModel.users.count)").foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .navigationBarTitle("Manage Users")
        .onAppear(){
            userbaseModel.loadExistingUsers()
        }
        
        /*
        VStack {
            
            
            List(userbaseModel.users) { user in
                NavigationLink {
                    TestView()
                } label: {
                    Label(user.username, systemImage: "person")
                }
            }
            Text("Total number of users: \(userbaseModel.users.count)").foregroundColor(.gray)
            Spacer()
        }
        .navigationBarTitle("Manage Users")
        .onAppear(){
            userbaseModel.loadExistingUsers()
        }
        .refreshable {
            //userbaseModel.loadExistingUsers()
        }
         */
    }
}

struct ManageUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageUsersView()
    }
}
