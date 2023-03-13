//
//  AdminControls.swift
//  UnlockIT
//
//  Created by Anton Lage on 21/02/2023.
//

import SwiftUI
import LocalAuthentication
import LocalAuthenticationEmbeddedUI

struct AdminControls: View {
    @EnvironmentObject private var userState: UserState
    @State private var companyUpdated: Bool = false

    var body: some View {
        
        VStack{
            
            if userState.isValidated {
                NavigationStack {
                    List {
                        NavigationLink{
                            RoomsView()
                        } label: {
                            Label("Manage Rooms", systemImage: "house.fill")
                        }
                        NavigationLink {
                            CreateUserView()
                        } label: {
                            Label("New User", systemImage: "person.badge.plus")
                        }
                        NavigationLink {
                            ManageUsersView()
                        } label: {
                            Label("Manage Users", systemImage: "person.2.badge.gearshape")
                        }
                        Button ("Set Company") {
                            let firebaseController = FirebaseController()
                            Task {
                                do {
                                    companyUpdated = try await firebaseController.SetUserCompanyName(companyName: "DTU")
                                }
                                catch {
                                    print(error)
                                }
                            }
                        }
                        .alert(isPresented: $companyUpdated) {
                            Alert(title: Text("Company Updated Successfully..."))
                        }
                    }
                    .navigationBarTitle("Admin Controls")
                }
            }
            else {
                Text("Not Authorized")
            }
        }
        .onAppear() {
            userState.validateUser()
        }
        .onDisappear() {
            userState.resetUserValidation()
        }
    }
}



struct AdminControls_Previews: PreviewProvider {
    static var previews: some View {
        AdminControls()
    }
}
