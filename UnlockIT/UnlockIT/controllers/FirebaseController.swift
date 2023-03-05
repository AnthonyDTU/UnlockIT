//
//  FirebaseController.swift
//  UnlockIT
//
//  Created by Anton Lage on 28/02/2023.
//

import Foundation
import Firebase


class FirebaseController {
    
    func CreateNewUser(adminUser: User, newUser: User) async -> Bool {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: newUser.email, password: newUser.password)
            
            let databaseRef = Database.database().reference()
            let data: [String : Any]  = ["username" : newUser.username,
                                         "position" : newUser.position,
                                         "department" : newUser.department,
                                         "privilege" : newUser.privilege,
                                         "email" : newUser.email,
                                         "isAdmin": newUser.isAdmin]
            
            try await databaseRef.child("Users/\(authResult.user.uid)").setValue(data)
            return true
        }
        catch {
            return false
        }
    }
        
        
    
    func SignIn(_ user: User, _ email: String, _ password: String) async -> Bool {
        do {
            let authResults = try await Auth.auth().signIn(withEmail: email, password: password)
            GetUserDataFromFirebase(user: user, userID: authResults.user.uid)
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    func GetUserDataFromFirebase(user: User, userID: String) {
        
        let databaseRef = Database.database().reference()
        databaseRef.child("Users/" + user.id).observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [String:Any] {
                user.configureUserData(userID: userID, data: data)
            }
        })
    }
}
