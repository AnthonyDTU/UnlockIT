//
//  User.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import Foundation

final class User: ObservableObject, Identifiable {
    @Published var id: String = "1"
    @Published var employeeNumber: Int = 1
    @Published var username: String = "Anton"
    @Published var email: String = "Test User"
    @Published var department: String = "R&D"
    @Published var position: String = "Engineer"
    @Published var password: String = "123"
    @Published var privilege: Int = 3
    @Published var isAdmin: Bool = true
    
    var subsribtions: [Subscription]?
    var collections: [Collection]?
    var personals: [Unlockable]?
    
    // Remove?
    init(id: String, employeeNumber: Int, username: String, email: String, department: String, companyPosition: String, password: String, privilege: Int, isAdmin: Bool) {
        self.id = id
        self.employeeNumber = employeeNumber
        self.username = username
        self.email = email
        self.department = department
        self.position = companyPosition
        self.password = password
        self.privilege = privilege
        self.isAdmin = isAdmin
    }
    
    init() {
        
    }
    
    
    func configureUserData(id: String, employeeNumber: Int, username: String, email: String, department: String, companyPosition: String, password: String, privilege: Int, isAdmin: Bool) {
        self.id = id
        self.employeeNumber = employeeNumber
        self.username = username
        self.email = email
        self.department = department
        self.position = companyPosition
        self.password = password
        self.privilege = privilege
        self.isAdmin = isAdmin
    }
    
    func configureUserData(userID: String, data: [String : Any]){
        self.id = userID
        self.employeeNumber = data["employeeNumber"] as! Int
        self.username = data["username"] as! String
        self.email = data["email"] as! String
        self.department = data["department"] as! String
        self.position = data["position"] as! String
        //self.password = data["password"] as! String
        self.privilege = data["privilege"] as! Int
        self.isAdmin = data["isAdmin"] as! Bool
    }
}


