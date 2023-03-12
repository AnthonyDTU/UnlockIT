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
            
            let data: [String : Any]  = ["username" : newUser.username,
                                         "position" : newUser.position,
                                         "employeeNumber" : newUser.employeeNumber,
                                         "department" : newUser.department,
                                         "privilege" : newUser.privilege,
                                         "email" : newUser.email,
                                         "isAdmin": newUser.isAdmin,
                                         "firstLogin": true]
            
            let myCompany = "DTU"
            let firestoreRef = Firestore.firestore()
            try await firestoreRef.collection("Companies").document(myCompany).collection("Users").document(authResult.user.uid).setData(data)
            
            let (email, password) = adminUser.loadCredentialsFromDevice()
            try await Auth.auth().signIn(withEmail: email, password: password)
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
            //GetUserDataFromFirebase(user: user, userID: authResults.user.uid)
            await GetUserDataFromFirestore(user: user, userID: authResults.user.uid)
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
    
    func GetUserDataFromFirestore(user: User, userID: String) async {
        
        do {
            let myCompany = "DTU"
            let firestore = Firestore.firestore()
            let documentSnapshot = try await firestore.collection("Companies").document(myCompany).collection("Users").document(userID).getDocument()
            if let data = documentSnapshot.data() {
                DispatchQueue.main.async {
                    user.configureUserData(userID: userID, data: data)
                }
            }
        }
        catch {
            print(error)
        }
    }
    

    func UpdateUser() {
        
        // This is just a database thing, so should be possible
    }
    
    func DeleteUser(){
        
        // AHHHHHG. Det kan man ikke uden brugerens password...
    }
}
