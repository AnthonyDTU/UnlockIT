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
        // Check if the user is already logged in to firebase backend
        isLoggedOut = Auth.auth().currentUser == nil
        
        // Create a listener for the login state in firebase, and update the local state accordingly
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.isLoggedOut = true            }
            else {
                self.isLoggedOut = false
            }
        }
    }
    
    func validateUser(){
        let context = LAContext()
        var error: NSError?
        
        // Check if the device has biometric functionallity
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return
        }
        
        // Biometrics are avaliable, so run check
        let reason = "We need to verify that it is really you using your phone"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            Task { @MainActor in
                self.isValidated = success
            }
            //DispatchQueue.main.async {
            //    self.isValidated = success
            //}
        }
    }
    
    func resetUserValidation() {
        isValidated = false
    }
}
