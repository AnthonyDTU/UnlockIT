//
//  UserState.swift
//  UnlockIT
//
//  Created by Anton Lage on 21/02/2023.
//

import Foundation
import Firebase
import LocalAuthentication

class UserState: ObservableObject {
    
    @Published var isLoggedOut: Bool = true
    @Published var isValidated: Bool = false
    
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
    
    func validateUser(){
        let context = LAContext()
        var error: NSError?
        var status : Bool = false
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    self.isValidated = success
                }
            }
        }
    }
    
    func resetUserValidation() {
        isValidated = false
    }
    
}
