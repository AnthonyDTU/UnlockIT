//
//  FirebaseController.swift
//  UnlockIT
//
//  Created by Anton Lage on 28/02/2023.
//

import Foundation
import Firebase

enum FirebaseControllerError: Error {
    case companyNameNotAvaliable
    case userIDNotAvailiable
}

/// Controller for interacting with the firebase backend, in relation to users.
/// This includes both authentication in the backend system, as well as storeing and fetching of user data
class FirebaseController {
    
    
    
    /// Creates a new user in the firebase Authentication database
    /// Also creates a document in thge firestore database with user information
    /// - Parameters:
    ///   - adminUser: The local administrator user object
    ///   - newUser: The local new user object
    ///   - newUserPassword: The password of the new user
    func CreateNewUser(adminUser: User, newUser: User, newUserPassword: String) async throws {
       
        // Crete the new user in firebase Authentication database
        let authResult = try await Auth.auth().createUser(withEmail: newUser.email, password: newUserPassword)
        
        // Set the new user's company name
        try await SetUserCompanyName(companyName: adminUser.company)
        
        // Create a data object with the new users information
        let data: [String : Any]  = ["username" : newUser.username,
                                     "position" : newUser.position,
                                     "employeeNumber" : newUser.employeeNumber,
                                     "company" : adminUser.company,
                                     "department" : newUser.department,
                                     "privilege" : newUser.privilege,
                                     "email" : newUser.email,
                                     "isAdmin": newUser.isAdmin,
                                     "firstLogin": true]
        
        // Store the new users information in a document in firestore
        try await StoreUserDataInFirestore(adminUser.company, authResult.user.uid, data)
        
        // Load the administrators credentials from userdefaults and log in to the administrator account (which was logged into before).
        // This has to be done, since firebase signs into the new user automatically
        try await ReAuthenticateAdmin(adminUser)
    }
    
    /// Creates and stores a document in firestore, containing the users information
    /// - Parameters:
    ///   - company: The company the user is associated with
    ///   - userID: The ID of the user
    ///   - data: The users data
    fileprivate func StoreUserDataInFirestore(_ company: String, _ userID: String, _ data: [String : Any]) async throws {
        let firestoreRef = Firestore.firestore()
        try await firestoreRef.collection("Companies").document(company).collection("Users").document(userID).setData(data)
    }
    
    /// Loads the stored admin credentials from userdefaults and re login to the admin user in firebase Authentication
    /// - Parameter adminUser: The local administrator user
    fileprivate func ReAuthenticateAdmin(_ adminUser: User) async throws {
        let (email, password) = try adminUser.loadCredentialsFromDevice()
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    /// Sign a user into firebase Authentication system,
    /// - Parameters:
    ///   - user: The user class on device
    ///   - email: The email of the user, used in firebase
    ///   - password: The password of the user, used in firebase
    func SignIn(_ user: User, _ email: String, _ password: String) async throws {
        
        try await Auth.auth().signIn(withEmail: email, password: password)
        DispatchQueue.main.async {
            do {
                try user.storeCredentialsOnDevice(email: email, password: password)
            }
            catch {
                print(error)
            }
        }
    }
    
    /// Updates a users password
    /// - Parameters:
    ///   - user: The user, whose password is to be updated (current user)
    ///   - newPassword: The users new password
    func UpdateUserPassword(user: User, newPassword: String) async throws {
        
        // Update the password of the current user
        try await Auth.auth().currentUser?.updatePassword(to: newPassword)
        
        // If password change is because of firstLogin rules, update the user locally and in firestore to reflect that the user has changed its password
        if user.firstLogin {
            try await Firestore.firestore().collection("Companies").document(user.company).collection("Users").document(user.userID).updateData(["firstLogin" : false])
            user.firstLogin = false
        }
    }
    
    /// Gets the user data for the logged in user from firestore database.
    /// - Parameter user: The local user object, where the fetched information is stored
    func GetUserDataFromFirestore(user: User) async throws {
        
        // Get the userid and the company the user belongs to
        guard let userID = Auth.auth().currentUser?.uid else { throw FirebaseControllerError.userIDNotAvailiable }
        guard let company = Auth.auth().currentUser?.displayName else { throw FirebaseControllerError.companyNameNotAvaliable }
        
        // Get the document containing this users information
        let firestore = Firestore.firestore()
        let documentSnapshot = try await firestore.collection("Companies").document(company).collection("Users").document(userID).getDocument()
        
        // Update the local user with the information from the fetched document
        if let data = documentSnapshot.data() {
            DispatchQueue.main.async {
                user.configureUserData(userID: userID, data: data)
            }
        }
    }
    
    
    /// Sets the company of the curret user in firebases Authentication database
    /// - Parameter companyName: The name of the company the current user works for
    func SetUserCompanyName(companyName: String) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = companyName
        try await changeRequest?.commitChanges()
    }
    
    
    /// Updates a users data in firestore database
    /// - Parameter updatedUser: The user who is to be updated
    func UpdateUserData(updatedUser: User) async throws {
        
        // Create a data object with the new users information
        let data: [String : Any]  = ["username" : updatedUser.username,
                                     "position" : updatedUser.position,
                                     "employeeNumber" : updatedUser.employeeNumber,
                                     "company" : updatedUser.company,
                                     "department" : updatedUser.department,
                                     "privilege" : updatedUser.privilege,
                                     "email" : updatedUser.email,
                                     "isAdmin": updatedUser.isAdmin,
                                     "firstLogin": updatedUser.firstLogin]
        
        // Try to update the data in firestore database
        try await Firestore.firestore().collection("Companies").document(updatedUser.company).collection("Users").document(updatedUser.userID).updateData(data)
    }
    
    func DeleteUser(){
        
        // AHHHHHG. Det kan man ikke uden brugerens password...
    }
}
