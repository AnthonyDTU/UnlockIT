//
//  UserState.swift
//  UnlockIT
//
//  Created by Anton Lage on 21/02/2023.
//

import Foundation
import Firebase

class UserState: ObservableObject {
    
    @Published var isLoggedOut: Bool = true
    
    init(){
        isLoggedOut = Auth.auth().currentUser == nil
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.isLoggedOut = true
                // Clear User Data?
            }
            else {
                self.isLoggedOut = false
                // Get User Data?
                
            }
        }
    }
        
    func SignIn(email: String, password: String) async -> Bool {
        do {
            let authResults = try await Auth.auth().signIn(withEmail: email, password: password)
            print(authResults.user.uid)
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    func createUser() {
        
    }
}
