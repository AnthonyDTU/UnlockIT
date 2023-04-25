//
//  MainView.swift
//  UnlockIT
//
//  Created by Anton Lage on 20/02/2023.
//

import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject private var appStyle: AppStyle
    @EnvironmentObject private var user : User
    @State private var showLoginScreen : Bool = false
    @State private var showChangePasswordScreen : Bool = false
    @State private var presentSheet : Bool = false
    
    var body: some View {
        
        NavigationView {
            // If a us
            if user.isLoggedOut {
                VStack {
                    Text("Login to use app features..",
                         comment: "Text telling the user to login in order to user the app's features. Only visible if the user has not yet logged in")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                    HStack {
                        Button(){
                            preparePresentSheet(_showLoginScreen: true, _showChangePasswordScreen: false)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Login",
                                     comment: "Text on a button, which lets the user navigate to the login screen")
                                Spacer()
                            }
                        }
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color.accentColor)
                        .cornerRadius(appStyle.cornerRadiusSmall)
                    }
                    .padding()
                }
            }
            else if user.firstLogin {
                VStack {
                    Text("Since it is your first login, you need to update your password before using the app",
                         comment: "Text telling the user, that since it is the first time he/she logs in, he/she must change the password")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                    
                    HStack {
                        Button(){
                            preparePresentSheet(_showLoginScreen: false, _showChangePasswordScreen: true)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Update Password",
                                     comment: "Text on a button, which lets the user navigate to the update password view")
                                Spacer()
                            }
                        }
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color.accentColor)
                        .cornerRadius(appStyle.cornerRadiusSmall)
                    }
                    .padding()
                    
                }
            }
            else{
                TabView{
                    HomeView()
                        .tabItem {
                            Label {
                                Text("Home",
                                     comment: "Home tabview button text")
                            } icon: {
                                Image(systemName: "house")
                            }
                        }
                    BookedRoomsView()
                        .tabItem {
                            Label {
                                Text("Booked Rooms",
                                     comment: "Booked Rooms tabview button text")
                            } icon: {
                                Image(systemName: "book")
                            }
                        }
                    
                    if user.isAdmin {
                        AdminControls()
                            .tabItem {
                                Label {
                                    Text("Admin Controls",
                                         comment: "Admin Controls tabview button text")
                                } icon: {
                                    Image(systemName: "bitcoinsign")
                                }
                        }
                    }
                }
            }
        }
        .onAppear() {
            if user.isLoggedOut == false {
                let firebaseController = FirebaseUserController()
                Task {
                    do {
                        try await firebaseController.GetUserDataFromFirestore(user: user)
                    }
                    catch {
                        print(error)
                    }
                }
            }
            showLoginScreen = user.isLoggedOut
        }
        .sheet(isPresented: $presentSheet) {
            if showLoginScreen {
                LoginView(showLoginView: $showLoginScreen)
            }
            else if showChangePasswordScreen {
                ChangePasswordOnFirstLoginView(showChangePasswordView: $showChangePasswordScreen)
            }
        }
    }
    
    
    func preparePresentSheet(_showLoginScreen: Bool, _showChangePasswordScreen: Bool) {
        guard _showLoginScreen ^ _showChangePasswordScreen else { return }
        showLoginScreen = _showLoginScreen
        showChangePasswordScreen = _showChangePasswordScreen
        presentSheet = true
    }
}



struct MainView_Previews: PreviewProvider {
    @StateObject static var appStyle = AppStyle()
    static var previews: some View {
        MainView().environmentObject(appStyle)
    }
}
