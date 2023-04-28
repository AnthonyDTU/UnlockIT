//
//  User.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import Foundation
import LocalAuthentication
import Firebase

enum UserError: Error {
    case emailNotFoundInUserDefaults
    case errorDecodingPassword
    case biometricsNotAvaliable
}

final class User: ObservableObject, Identifiable, Hashable {
    
    
    internal var authContext = LAContext()
    
    struct credentialKeys {
        static let emailKey = "UnlockIT_emailKey"
    }
    
    @Published var userID: String = ""
    @Published var employeeNumber: Int = 0
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var company: String = ""
    @Published var department: String = ""
    @Published var position: String = ""
    @Published var privilege: Int = 1
    @Published var isAdmin: Bool = false
    @Published var firstLogin: Bool = false
    
    // State
    @Published var isLoggedOut: Bool = true
    @Published var isValidated: Bool = false
    
    var id: String {
        return userID
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
   
    init() {
        
        let arguments = ProcessInfo.processInfo.arguments
        let UITesting = arguments.contains("UI_TESTING")
            
        if (UITesting == false) {
            // Check if the user is already logged in to firebase backend
            isLoggedOut = Auth.auth().currentUser == nil
            
            // Create a listener for the login state in firebase, and update the local state accordingly
            Auth.auth().addStateDidChangeListener { auth, user in
                if user == nil {
                    self.isLoggedOut = true
                }
                else {
                    self.isLoggedOut = false
                }
            }
        }
    }
    
    init(name: String) {
        self.username = name
    }

    
    func configureUserData(userID: String, data: [String : Any]) {
        self.userID = userID
        self.employeeNumber = data["employeeNumber"] as! Int
        self.username = data["username"] as! String
        self.email = data["email"] as! String
        self.company = data["company"] as! String
        self.department = data["department"] as! String
        self.position = data["position"] as! String
        self.privilege = data["privilege"] as! Int
        self.isAdmin = data["isAdmin"] as! Bool
        self.firstLogin = data["firstLogin"] as! Bool
    }
    
    
    /// Stores the users credentials in persistent storage
    /// Email is stored in userdefaults, and password is stored in keychain with email as an attribute
    /// - Parameters:
    ///   - email: The users email
    ///   - password: The users password
    func storeCredentialsOnDevice(email: String, password: String) throws {
        UserDefaults.standard.set(email, forKey: credentialKeys.emailKey)
        
        let keychainManager = KeychainManager()
        try keychainManager.storeValue(key: email, data: password.data(using: .utf8)!)
        
    }
    
    /// Loads the users email from userdefaults, and the password from keychain
    /// - Returns: Tuple containing (Email, Password)
    func loadCredentialsFromDevice() throws -> (String, String) {

        guard let email = UserDefaults.standard.string(forKey: credentialKeys.emailKey) else {
            throw UserError.emailNotFoundInUserDefaults
        }
        
        let keychainManager = KeychainManager()
        guard let loadedData = try keychainManager.fetchValue(key: email) else {
            throw UserError.errorDecodingPassword
        }

        let password = String(decoding: loadedData, as: UTF8.self)
        return (email, password)
    }
    
    /// Validates the user via biometric authentication, if avaliable
    func validateUser() async throws {
        
        var error: NSError?
        
        // Check if the device has biometric functionallity
        guard authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw UserError.biometricsNotAvaliable
        }
        
        // Biometrics are avaliable, so run check
        let reason = String(localized: "We need to verify that it is really you using your phone", comment: "localized reason for why FaceID should be accessed")
        
        let status = try await authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        
        DispatchQueue.main.async {
            self.isValidated = status
        }
    }
    
    
    /// Resets the authentication, so the user will have to reauthenticate next time restricted functinallity is accessed
    func resetUserValidation() {
        self.isValidated = false
        authContext = LAContext()
    }
}



