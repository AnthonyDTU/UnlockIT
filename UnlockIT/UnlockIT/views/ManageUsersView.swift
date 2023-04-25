//
//  ManageUsers.swift
//  UnlockIT
//
//  Created by Anton Lage on 06/03/2023.
//

import SwiftUI

struct ManageUsersView: View {
    
    @EnvironmentObject private var user: User
    @StateObject private var userbaseModel = UserbaseViewModel()
    @State private var showAlert = false
    @State private var alertText = ""
    
    
    var body: some View {
        
            List {
                if !userbaseModel.finishedLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                else {
                    
                    Section(header: Text("Administrators",
                                         comment: "Section Header for the administrators section in ManageUsersView")) {
                        
                        ForEach(userbaseModel.getAdministrators(), id: \.self) { user in
                            NavigationLink {
                                EditUserView(user: $userbaseModel.users[userbaseModel.users.firstIndex(of: user) ?? 0])
                            } label: {
                                Label(user.username, systemImage: "person")
                            }
                        }
                    }
                    
                    Section(header: Text("Users", comment: "Section Header for the user section in ManageUsersView")) {
                        ForEach(userbaseModel.getNonAdministrators(), id: \.self) { user in
                            NavigationLink {
                                EditUserView(user: $userbaseModel.users[userbaseModel.users.firstIndex(of: user) ?? 0])
                            } label: {
                                Label(user.username, systemImage: "person")
                            }
                        }
                    }
                    
                    VStack {
                        HStack{
                            Spacer()
                            Text("\(userbaseModel.users.count) User(s) In Total", comment: "Text stating the total number of users").foregroundColor(.gray)
                            
                            //Text("[\(userbaseModel.users.count) User] (inflect: true) In Total", comment: "Text stating the total number of users").foregroundColor(.gray)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "Manage Users", comment: "Navigation title for ManageUsersView"))
            .onAppear(){
                Task {
                    do {
                        try await userbaseModel.loadExistingUsersFromFirestore(company: user.company)
                    }
                    catch{
                        // Show message to user
                        alertText = String(localized: "Error loading users from database", comment: "Error Message")
                        showAlert = true
                        print(error)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                NavigationLink {
                    CreateUserView()
                } label: {
                    Image(systemName: "person.badge.plus")
                }
            }
            .refreshable {
                do {
                    try await userbaseModel.loadExistingUsersFromFirestore(company: user.company)
                }
                catch {
                    // Show message to user
                    alertText = String(localized: "Error updating users from database", comment: "Error Message")
                    showAlert = true
                    print(error)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertText))
            }
    }
}

struct ManageUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageUsersView()
    }
}
