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

final class User: ObservableObject, Identifiable, Hashable {
    
    @Published var userID: String = "1"
    @Published var employeeNumber: Int = 1
    @Published var username: String = "Anton"
    @Published var email: String = "Test User"
    @Published var department: String = "R&D"
    @Published var position: String = "Engineer"
    @Published var privilege: Int = 3
    @Published var isAdmin: Bool = false
    @Published var isFirstLogin: Bool = false
    
    var id: String {
        return userID
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
    
    
    // Remove?
    init(userID: String, employeeNumber: Int, username: String, email: String, department: String, companyPosition: String, privilege: Int, isAdmin: Bool, isFirstLogin: Bool) {
        self.userID = userID
        self.employeeNumber = employeeNumber
        self.username = username
        self.email = email
        self.department = department
        self.position = companyPosition
        self.privilege = privilege
        self.isAdmin = isAdmin
        self.isFirstLogin = isFirstLogin
    }
    
    init() {
        
    }
    
    
    func configureUserData(userID: String, employeeNumber: Int, username: String, email: String, department: String, companyPosition: String, privilege: Int, isAdmin: Bool, isFirstLogin: Bool) {
        self.userID = userID
        self.employeeNumber = employeeNumber
        self.username = username
        self.email = email
        self.department = department
        self.position = companyPosition
        self.privilege = privilege
        self.isAdmin = isAdmin
        self.isFirstLogin = isFirstLogin
    }
    
    func configureUserData(userID: String, data: [String : Any]) {
        self.userID = userID
        self.employeeNumber = data["employeeNumber"] as! Int
        self.username = data["username"] as! String
        self.email = data["email"] as! String
        self.department = data["department"] as! String
        self.position = data["position"] as! String
        self.privilege = data["privilege"] as! Int
        self.isAdmin = data["isAdmin"] as! Bool
        self.isFirstLogin = data["firstLogin"] as! Bool
    }
    
    
    func storeCredentialsOnDevice(email: String, password: String) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: credentialsKeys.emailKey)
        defaults.set(password, forKey: credentialsKeys.passwordKey)
    }
    
    func loadCredentialsFromDevice() -> (String, String){
        let defaults = UserDefaults.standard
        var email: String = ""
        var password: String = ""
        
        if let loadedEmail = defaults.string(forKey: credentialsKeys.emailKey) {
            email = loadedEmail
        }
        if let loadedPassword = defaults.string(forKey: credentialsKeys.passwordKey) {
            password = loadedPassword
        }
        return (email, password)
    }
}


