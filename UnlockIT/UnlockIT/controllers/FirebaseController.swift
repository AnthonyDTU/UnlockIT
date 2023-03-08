//
//  FirebaseController.swift
//  UnlockIT
//
//  Created by Anton Lage on 28/02/2023.
//

import Foundation
import Firebase


class FirebaseController {
    
    func CreateNewUser(adminUser: User, newUser: User, newUserPassword: String) async -> Bool {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: newUser.email, password: newUserPassword)
            
            let databaseRef = Database.database().reference()
            let data: [String : Any]  = ["username" : newUser.username,
                                         "position" : newUser.position,
                                         "department" : newUser.department,
                                         "privilege" : newUser.privilege,
                                         "email" : newUser.email,
                                         "isAdmin": newUser.isAdmin,
                                         "firstLogin": true]
            
            try await databaseRef.child("Users/\(authResult.user.uid)").setValue(data)
            
            let (email, password) = adminUser.loadCredentialsFromDevice()
            try await Auth.auth().signIn(withEmail: email, password: password)
            //_ = await SignIn(adminUser, email, password)
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    func SignIn(_ user: User, _ email: String, _ password: String) async -> Bool {
        do {
            let authResults = try await Auth.auth().signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                user.storeCredentialsOnDevice(email: email, password: password)
            }
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
        databaseRef.child("Users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [String : Any]{
                DispatchQueue.main.async {
                    user.configureUserData(userID: userID, data: data)
                }
            }
        })
    }
    

    func UpdateUser() {
        
        // This is just a database thing, so should be possible
    }
    
    func DeleteUser(){
        
        // AHHHHHG. Det kan man ikke uden brugerens password...
    }
}
