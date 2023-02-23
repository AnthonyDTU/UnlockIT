//
//  UnlockITApp.swift
//  UnlockIT
//
//  Created by Anton Lage on 16/02/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


@main
struct UnlockITApp: App {
    @StateObject private var user = User()
    @StateObject private var userState = UserState()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(user)
                .environmentObject(userState)
        }
    }
}
