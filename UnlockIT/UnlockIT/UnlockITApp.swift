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

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let arguments = ProcessInfo.processInfo.arguments
    for argument in arguments {
        switch argument {
        case "UI_TESTING":
            let test = ""
            break
            
        default:
            break
        }
        
    }
    return true
}

@main
struct UnlockITApp: App {
    @StateObject private var appStyle = AppStyle()
    @StateObject private var user = User()
    @StateObject private var roomsModel = RoomsModel()
    
    init(){
        FirebaseApp.configure()
        
        let arguments = ProcessInfo.processInfo.arguments
        for argument in arguments {
            switch argument {
            case "UI_TESTING":
                if let isAdmin = ProcessInfo.processInfo.environment["ADMIN_STATUS"] {
                    self.user.isAdmin = isAdmin == "TRUE"
                }
                
                if let isFirstLogin = ProcessInfo.processInfo.environment["FIRST_LOGIN"] {
                    self.user.firstLogin = isFirstLogin == "TRUE"
                }
                
                
                
            default:
                break
            }
        }
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
