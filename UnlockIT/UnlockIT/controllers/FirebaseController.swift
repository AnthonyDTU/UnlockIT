//
//  FirebaseController.swift
//  UnlockIT
//
//  Created by Anton Lage on 28/02/2023.
//

import Foundation
import Firebase


class FirebaseController {
    
    func CreateNewUser(adminUser: User, newUser: User, newUserPassword: String) async throws {
       
        let authResult = try await Auth.auth().createUser(withEmail: newUser.email, password: newUserPassword)
        
        try await SetUserCompanyName(companyName: adminUser.company)
        
        let data: [String : Any]  = ["username" : newUser.username,
                                     "position" : newUser.position,
                                     "employeeNumber" : newUser.employeeNumber,
                                     "company" : adminUser.company,
                                     "department" : newUser.department,
                                     "privilege" : newUser.privilege,
                                     "email" : newUser.email,
                                     "isAdmin": newUser.isAdmin,
                                     "firstLogin": true]
        
        let firestoreRef = Firestore.firestore()
        try await firestoreRef.collection("Companies").document(adminUser.company).collection("Users").document(authResult.user.uid).setData(data)
        
        let (email, password) = adminUser.loadCredentialsFromDevice()
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func SignIn(_ user: User, _ email: String, _ password: String) async -> Bool {
        do {
            let authResults = try await Auth.auth().signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                user.storeCredentialsOnDevice(email: email, password: password)
            }
            
            guard let company = authResults.user.displayName else { return false }
            await GetUserDataFromFirestore(user: user, userID: authResults.user.uid, company: company)
            
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    func UpdateUserPassword(user: User, newPassword: String) async -> Bool {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: newPassword)
            let firestoreRef = Firestore.firestore().collection("Companies").document(user.company).collection("Users").document(user.userID)
            try await firestoreRef.updateData(["firstLogin" : false])
            user.isFirstLogin = false
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    func GetUserDataFromFirestore(user: User, userID: String, company: String) async {
        
        do {
            let firestore = Firestore.firestore()
            let documentSnapshot = try await firestore.collection("Companies").document(company).collection("Users").document(userID).getDocument()
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
    
    func SetUserCompanyName(companyName: String) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = companyName
        try await changeRequest?.commitChanges()
    }
    

    func UpdateUser() {
        
        // This is just a database thing, so should be possible
    }
    
    func DeleteUser(){
        
        // AHHHHHG. Det kan man ikke uden brugerens password...
    }
}
