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
    @EnvironmentObject private var user: User
    @State private var companyUpdated: Bool = false

    var body: some View {
        
        VStack{
            if user.isValidated {
                NavigationStack {
                    List {
                        NavigationLink {
                            ManageUsersView()
                        } label: {
                            Label("Manage Users", systemImage: "person.2.badge.gearshape")
                        }
                        NavigationLink {
                            RoomsView()
                        } label: {
                            Label("Manage Rooms", systemImage: "house.fill")
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
            Task {
                do {
                    try await user.validateUser()
                }
                catch {
                    print(error)
                }
            }
        }
        .onDisappear() {
            user.resetUserValidation()
        }
    }
}

struct AdminControls_Previews: PreviewProvider {
    static var previews: some View {
        AdminControls()
    }
}
