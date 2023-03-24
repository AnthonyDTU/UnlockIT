//
//  User.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import Foundation
import LocalAuthentication
import Firebase

struct credentialKeys {
    static let emailKey = "UnlockIT_emailKey"
    static let passwordKey = "UnlockIT_passwordKey"
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case encodingError
    case unhandledError(status: OSStatus)
}



final class User: ObservableObject, Identifiable, Hashable {
    
    @Published var userID: String = ""
    @Published var employeeNumber: Int = 0
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var company: String = ""
    @Published var department: String = ""
    @Published var position: String = ""
    @Published var privilege: Int = 1
    @Published var isAdmin: Bool = false
    @Published var isFirstLogin: Bool = false
    
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
        self.isFirstLogin = data["firstLogin"] as! Bool
    }
    
    
    /// Stores the users credentials in persistent storage
    /// Email is stored in userdefaults, and password is stored in keychain with email as an attribute
    /// - Parameters:
    ///   - email: The users email
    ///   - password: The users password
    func storeCredentialsOnDevice(email: String, password: String) throws {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: credentialKeys.emailKey)
        defaults.set(password, forKey: credentialKeys.passwordKey)
        
        
        guard let encodedPassword: Data = password.data(using: String.Encoding.utf8) else { throw KeychainError.encodingError }
        
        var query: [String: Any] = [kSecAttrAccount as String: email]
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        // 4
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword
              
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw KeychainError.unhandledError(status: status)
            }
        // 5
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedPassword
          
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw KeychainError.unhandledError(status: status)
            }
        default:
            throw KeychainError.unhandledError(status: status)
        }
        
        
        
        /*
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: email,
                                    kSecValueData as String: encodedPassword]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
         */
    }
    
    /// Loads the users email from userdefaults, and the password from keychain
    /// - Returns: Tuple containing Email, Password
    func loadCredentialsFromDevice() throws -> (String, String) {
        var email: String = ""
        var password: String = ""
        
        if let loadedEmail = UserDefaults.standard.string(forKey: credentialKeys.emailKey) {
            email = loadedEmail
            
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrAccount as String: loadedEmail,
                                        kSecMatchLimit as String: kSecMatchLimitOne,
                                        kSecReturnAttributes as String: false,
                                        kSecReturnData as String: true]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            guard status != errSecItemNotFound else { throw KeychainError.noPassword }
            guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    
            guard let existingItem = item as? [String : Any],
                  let passwordData = existingItem[kSecValueData as String] as? Data
            else {
                throw KeychainError.unexpectedPasswordData
            }
            
            let testpassword = String(data: passwordData, encoding: String.Encoding.utf8) ?? ""
             
        }
        
        if let loadedPassword = UserDefaults.standard.string(forKey: credentialKeys.passwordKey) {
            password = loadedPassword
        }
        
        return (email, password)
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


