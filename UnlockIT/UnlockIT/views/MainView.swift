//
//  MainView.swift
//  UnlockIT
//
//  Created by Anton Lage on 20/02/2023.
//

import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var user : User
    @EnvironmentObject var userState : UserState
    @State private var showLoginScreen : Bool = false
    
    var body: some View {
        
        NavigationView {
            if userState.isLoggedOut {
                VStack {
                    Text("Login to use app features..")
                    Button("Login"){
                        showLoginScreen = true
                    }
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
                    AccountView()
                        .tabItem {
                            Label("Account Info", systemImage: "person")
                        }
                }
            }
        }
        .onAppear() {
            if userState.isLoggedOut == false {
                user.email = Auth.auth().currentUser?.email ?? "(unkown)"
            }
            showLoginScreen = userState.isLoggedOut
        }
        .sheet(isPresented: $showLoginScreen) {
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
