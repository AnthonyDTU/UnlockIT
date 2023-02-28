//
//  User.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import Foundation

final class User: ObservableObject, Identifiable{
    @Published var id: String = "1"
    @Published var name: String = "Anton"
    @Published var email: String = "Test User"
    @Published var department: String = "R&D"
    @Published var companyPosition: String = "Engineer"
    @Published var password: String = "123"
    @Published var privilege: Int = 3
    @Published var isAdmin: Bool = true
    
    init(id: String, name: String, email: String, department: String, companyPosition: String, password: String, privilege: Int, isAdmin: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.department = department
        self.companyPosition = companyPosition
        self.password = password
        self.privilege = privilege
        self.isAdmin = isAdmin
    }
    
    init() {
        
    }
    // More details - to be implemented
    
    //init() {
    //
    //}
    
    
}


