//
//  FirebaseController.swift
//  UnlockIT
//
//  Created by Anton Lage on 28/02/2023.
//

import Foundation
import Firebase

class FirebaseController {
    
    func SignIn(user: User, email: String, password: String) async -> Bool {
        do {
            let authResults = try await Auth.auth().signIn(withEmail: email, password: password)
            print(authResults.user.uid)
            GetUserDataFromFirebase(user: user)
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    func GetUserDataFromFirebase(user: User) {
        
    }
    
    
}
