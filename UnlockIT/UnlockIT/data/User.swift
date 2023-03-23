//
//  User.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import Foundation

struct credentialsKeys {
    static let emailKey = "UnlockIT_emailKey"
    static let passwordKey = "UnlockIT_passwordKey"
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
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
    @Published var userState: UserState = UserState()
    
    
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
    
    
    func storeCredentialsOnDevice(email: String, password: String) throws {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: credentialsKeys.emailKey)
        
        defaults.set(password, forKey: credentialsKeys.passwordKey)
        /*
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: email,
                                    kSecValueData as String: encodedPassword]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
         */
        
    }
    
    func loadCredentialsFromDevice() throws -> (String, String) {
        let defaults = UserDefaults.standard
        var email: String = ""
        var password: String = ""
        
        if let loadedEmail = defaults.string(forKey: credentialsKeys.emailKey) {
            email = loadedEmail
            /*
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
            
            password = String(data: passwordData, encoding: String.Encoding.utf8) ?? ""
             */
        }
        if let loadedPassword = defaults.string(forKey: credentialsKeys.passwordKey) {
            password = loadedPassword
        }
        
        return (email, password)
    }
}


