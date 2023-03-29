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
    @StateObject private var appStyle = AppStyle()
    @StateObject private var user = User()
    @StateObject private var roomsModel = RoomsModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appStyle)
                .environmentObject(user)
                .environmentObject(roomsModel)
        }
    }
}
