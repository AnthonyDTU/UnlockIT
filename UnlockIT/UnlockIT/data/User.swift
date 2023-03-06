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

enum CodingKeys: CodingKey {
    case id, employeeNumber, username, email, department, position, privilege, isAdmin
}

final class User: ObservableObject, Identifiable, Codable {
    @Published var id: String = "1"
    @Published var employeeNumber: Int = 1
    @Published var username: String = "Anton"
    @Published var email: String = "Test User"
    @Published var department: String = "R&D"
    @Published var position: String = "Engineer"
    @Published var privilege: Int = 3
    @Published var isAdmin: Bool = true
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(employeeNumber, forKey: .employeeNumber)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(department, forKey: .department)
        try container.encode(position, forKey: .position)
        try container.encode(privilege, forKey: .privilege)
        try container.encode(isAdmin, forKey: .isAdmin)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        employeeNumber = try container.decode(Int.self, forKey: .employeeNumber)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        department = try container.decode(String.self, forKey: .department)
        position = try container.decode(String.self, forKey: .position)
        privilege = try container.decode(Int.self, forKey: .privilege)
        isAdmin = try container.decode(Bool.self, forKey: .isAdmin)
    }
    
    
    // Remove?
    init(id: String, employeeNumber: Int, username: String, email: String, department: String, companyPosition: String, privilege: Int, isAdmin: Bool) {
        self.id = id
        self.employeeNumber = employeeNumber
        self.username = username
        self.email = email
        self.department = department
        self.position = companyPosition
        self.privilege = privilege
        self.isAdmin = isAdmin
    }
    
    init() {
        
    }
    
    
    func configureUserData(id: String, employeeNumber: Int, username: String, email: String, department: String, companyPosition: String, privilege: Int, isAdmin: Bool) {
        self.id = id
        self.employeeNumber = employeeNumber
        self.username = username
        self.email = email
        self.department = department
        self.position = companyPosition
        self.privilege = privilege
        self.isAdmin = isAdmin
    }
    
    func configureUserData(userID: String, data: [String : Any]) {
        self.id = userID
        self.employeeNumber = data["employeeNumber"] as! Int
        self.username = data["username"] as! String
        self.email = data["email"] as! String
        self.department = data["department"] as! String
        self.position = data["position"] as! String
        self.privilege = data["privilege"] as! Int
        self.isAdmin = data["isAdmin"] as! Bool
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


