//
//  FirebaseController.swift
//  UnlockIT
//
//  Created by Anton Lage on 28/02/2023.
//

import Foundation
import Firebase


class FirebaseController {
    
    func CreateUser() {
        
    }
    
    func SignIn(user: User, email: String, password: String) async -> Bool {
        do {
            let authResults = try await Auth.auth().signIn(withEmail: email, password: password)
            user.id = authResults.user.uid
            GetUserDataFromFirebase(user: user)
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    func GetUserDataFromFirebase(user: User) {
        
        let databaseRef = Database.database().reference()
        databaseRef.child("Users/" + user.id).observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [String:Any] {
                user.name = data["username"] as! String
                user.privilege = data["level"] as! Int
                user.companyPosition = data["position"] as! String
                user.department = data["department"] as! String
            }
        })
    }
    
    
    
    
}
