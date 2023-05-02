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
    @State private var requestedView : RequestableViews = .loginView
    @State private var presentSheet : Bool = false
    
    var body: some View {
        
        NavigationView {
            // If a user is logged out
            if user.isLoggedOut {
                VStack {
                    Text("Login to use app features..",
                         comment: "Text telling the user to login in order to user the app's features. Only visible if the user has not yet logged in")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                    HStack {
                        Button(){
                            requestedView = .loginView
                            presentSheet = true
                            //preparePresentSheet(_showLogin: true, _showChangePassword: false)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Login",
                                     comment: "Text on a button, which lets the user navigate to the login screen")
                                Spacer()
                            }
                        }
                        .accessibilityIdentifier("GoToLoginPageButton")
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color.accentColor)
                        .cornerRadius(appStyle.cornerRadiusSmall)
                    }
                    .padding()
                }
            }
            // If it is the first time a user is loggin in
            else if user.firstLogin {
                VStack {
                    Text("Since it is your first login, you need to update your password before using the app",
                         comment: "Text telling the user, that since it is the first time he/she logs in, he/she must change the password")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                    
                    HStack {
                        Button(){
                            requestedView = .changePasswordView
                            presentSheet = true
                            //preparePresentSheet(_showLogin: false, _showChangePassword: true)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Update Password",
                                     comment: "Text on a button, which lets the user navigate to the update password view")
                                Spacer()
                            }
                        }
                        .accessibilityIdentifier("GoToUpdatePasswordScreenButton")
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color.accentColor)
                        .cornerRadius(appStyle.cornerRadiusSmall)
                    }
                    .padding()
                    
                    HStack {
                        Button(){
                            let firebaseUserController = FirebaseUserController()
                    
                            do { try firebaseUserController.SingOut() }
                            catch { print(error) }
                            
                        } label: {
                            HStack {
                                Spacer()
                                Text("Log Out",
                                     comment: "Text on a button, which logs the user out")
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
                            .accessibilityIdentifier("TabbarHomeButton")
                        }
                    BookedRoomsView()
                        .tabItem {
                            Label {
                                Text("Booked Rooms",
                                     comment: "Booked Rooms tabview button text")
                            } icon: {
                                Image(systemName: "book")
                            }
                            .accessibilityIdentifier("TabbarBookedRoomsButton")
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
                                .accessibilityIdentifier("TabbarAdminControlsButton")
                            }
                    }
                }
                .accessibilityIdentifier("mainTabBar")
            }
        }
        .onAppear() {
            var UITesting = false
            let arguments = ProcessInfo.processInfo.arguments
            for argument in arguments {
                switch argument {
                case "UI_TESTING":
                    UITesting = true
                    if let isAdmin = ProcessInfo.processInfo.environment["ADMIN_STATUS"] {
                        user.isAdmin = isAdmin == "TRUE"
                    }
                    
                    if let isFirstLogin = ProcessInfo.processInfo.environment["FIRST_LOGIN"] {
                        user.firstLogin = isFirstLogin == "TRUE"
                    }
                    
                    if let isLoggedIn = ProcessInfo.processInfo.environment["IS_LOGGED_IN"] {
                        user.isLoggedOut = isLoggedIn == "FALSE"
                    }
                    
                    if let isValidated = ProcessInfo.processInfo.environment["IS_VALIDATED"] {
                        user.isValidated = isValidated == "TRUE"
                    }
                    
                default:
                    break
                }
            }
            
            // Login if the user has not been automatically done so.
            // Skip if UI Testing is in progress
            if UITesting == false && user.isLoggedOut == false {
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
        }
        .sheet(isPresented: $presentSheet) {
            MainScreenSheetView(requestedView: $requestedView)
        }
    }
}



struct MainView_Previews: PreviewProvider {
    @StateObject static var appStyle = AppStyle()
    static var previews: some View {
        MainView().environmentObject(appStyle)
    }
}
