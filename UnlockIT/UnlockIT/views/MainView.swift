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
    @EnvironmentObject private var userState : UserState
    @State private var showLoginScreen : Bool = false
    @State private var showChangePasswordScreen : Bool = false
    @State private var presentSheet : Bool = false
    
    var body: some View {
        
        NavigationView {
            if userState.isLoggedOut {
                VStack {
                    Text("Login to use app features..")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                    HStack {
                        Button(){
                            showLoginScreen = true
                            presentSheet = true
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
                            showChangePasswordScreen = true
                            presentSheet = true
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
            if userState.isLoggedOut == false {
                let firebaseController = FirebaseController()
                Task {
                    do {
                        try await firebaseController.GetUserDataFromFirestore(user: user, userID: Auth.auth().currentUser!.uid, company: "DTU")
                    }
                    catch {
                        print(error)
                    }
                }
            }
            showLoginScreen = userState.isLoggedOut
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
}

struct MainView_Previews: PreviewProvider {
    @StateObject static var appStyle = AppStyle()
    
    static var previews: some View {
        MainView().environmentObject(appStyle)
    }
}
