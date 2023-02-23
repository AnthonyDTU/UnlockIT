//
//  User.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 17/02/2023.
//

import Foundation
import FirebaseAuth

final class User: ObservableObject{
    @Published var email: String = "Test User"
    @Published var department: String = "R&D"
    @Published var companyPosition: String = "Engineer"
    @Published var password: String = "123"
    @Published var privilege: Int = 3
    @Published var isAdmin: Bool = true
    
    
    
    // More details - to be implemented
    
    //init() {
    //
    //}
    
    
}


