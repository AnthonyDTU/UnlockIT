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
            if user.state.isLoggedOut {
                VStack {
                    Text("Login to use app features..")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                    HStack {
                        Button(){
                            preparePresentSheet(_showLoginScreen: true, _showChangePasswordScreen: false)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Login")
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
            else if (user.isFirstLogin) {
                VStack {
                    Text("Since it is your first login, you need to update your password before using the app")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                    
                    HStack {
                        Button(){
                            preparePresentSheet(_showLoginScreen: false, _showChangePasswordScreen: true)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Update Password")
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
                            Label("Home", systemImage: "house")
                        }
                    BookedRoomsView()
                        .tabItem {
                            Label("Booked Rooms", systemImage: "book")
                        }
                    
                    if user.isAdmin {
                        AdminControls()
                            .tabItem {
                            Label("Admin Controls", systemImage: "bitcoinsign")
                        }
                    }
                }
            }
        }
        .onAppear() {
            if user.state.isLoggedOut == false {
                let firebaseController = FirebaseController()
                Task {
                    do {
                        try await firebaseController.GetUserDataFromFirestore(user: user)
                    }
                    catch {
                        print(error)
                    }
                }
            }
            showLoginScreen = user.state.isLoggedOut
        }
        .sheet(isPresented: $presentSheet) {
            if showLoginScreen {
                LoginView(showLoginView: $showLoginScreen)
            }
            else if showChangePasswordScreen {
                ChangePasswordView(showChangePasswordView: $showChangePasswordScreen)
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

// Move
extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}

struct MainView_Previews: PreviewProvider {
    @StateObject static var appStyle = AppStyle()
    
    static var previews: some View {
        MainView().environmentObject(appStyle)
    }
}
