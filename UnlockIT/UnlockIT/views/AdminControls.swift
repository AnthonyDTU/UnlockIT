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

    var body: some View {
        
        VStack{
            if user.isValidated {
                NavigationView {
                    List {
                        NavigationLink {
                            ManageUsersView()
                        } label: {
                            Label {
                                Text("Manage Users",
                                     comment: "Navigation Link for navigating to the mangage users view")
                            } icon: {
                                Image(systemName: "person.2.badge.gearshape")
                            }
                            .accessibilityIdentifier("ManageUsersNavigationLink")
                        }
                        NavigationLink {
                            RoomsView()
                        } label: {
                            Label {
                                Text("Manage Rooms",
                                     comment: "Navigation Link for navigation to the manage rooms view")
                            } icon: {
                                Image(systemName: "house.fill")
                            }
                            .accessibilityIdentifier("ManageRoomsNavigationLink")
                        }
                    }
                    .navigationBarTitle(String(localized: "Admin Controls",
                                               comment: "Navigation Bar Title for the Admin Controls view"))
                }
            }
            else {
                Text("Not Authorized",
                     comment: "Label telling the user, that he/she is not authorized to access the administrator controls. Related to local authenitcation.")
            }
        }
        //.toolbar(.visible, for: .tabBar)
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
