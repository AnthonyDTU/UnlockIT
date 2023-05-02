//
//  UserbaseViewModel.swift
//  UnlockIT
//
//  Created by Anton Lage on 06/03/2023.
//

import Foundation
import FirebaseFirestore

final class UserbaseViewModel : ObservableObject {
    @Published var users: [User] = []
    @Published var finishedLoading: Bool = false
    
    
    /// Load all existing users in a company from friestore database
    /// - Parameter company: The company from which the users should be loaded
    func loadExistingUsersFromFirestore(company: String) async throws {
        
        DispatchQueue.main.async {
            self.users.removeAll()
            self.finishedLoading = false
        }

        var UITesting = false
        let arguments = ProcessInfo.processInfo.arguments
        for argument in arguments {
            switch argument {
            case "UI_TESTING":
                UITesting = true
                if let numberOfUsers = Int(ProcessInfo.processInfo.environment["NUMBER_OF_USERS_IN_USERBASE"]!) {
                    
                    if numberOfUsers == 1 {
                        let user = User()
                        user.configureUserData(userID: "1", data: [
                            "username" : String("user 1"),
                            "employeeNumber" : 1,
                            "email" : String("user1@test.com"),
                            "company" : "testCompany",
                            "department" : "UnitTesting",
                            "position" : "tester",
                            "privilege" : 1,
                            "isAdmin" : true,
                            "firstLogin" : false
                        ])
                        
                        DispatchQueue.main.async {
                            self.users.append(user)
                        }
                    }
                    else if numberOfUsers > 1 {
                        for index in 1...numberOfUsers {
                            let user = User()
                            user.configureUserData(userID: String(index), data: [
                                "username" : String("user \(index)"),
                                "employeeNumber" : index,
                                "email" : String("user\(index)@test.com"),
                                "company" : "testCompany",
                                "department" : "UnitTesting",
                                "position" : "tester",
                                "privilege" : index,
                                "isAdmin" : index % 2 == 0,
                                "firstLogin" : index % 2 != 0
                            ])
                            
                            DispatchQueue.main.async {
                                self.users.append(user)
                            }
                        }
                    }
                }
                
            default:
                break
            }
        }
        if UITesting == false {
            let firestore = Firestore.firestore()
            let collectionSnapshot = try await firestore.collection("Companies").document(company).collection("Users").getDocuments()
            for document in collectionSnapshot.documents {
                let data = document.data()
                let user = User()
                user.configureUserData(userID: document.documentID, data: data)
                DispatchQueue.main.async {
                    self.users.append(user)
                }
            }
        }

        DispatchQueue.main.async {
            self.finishedLoading = true
        }
    }
    
    func getAdministrators() -> [User] {
        return sort(forAdmin: true)
    }
    
    func getNonAdministrators() -> [User] {
        return sort(forAdmin: false)
    }
    
    private func sort(forAdmin: Bool) -> [User] {
        
        var foundUsers: [User] = []
        for user in users {
            if forAdmin && user.isAdmin { foundUsers.append(user) }
            else if !forAdmin && !user.isAdmin { foundUsers.append(user) }
        }
        return foundUsers
    }
}
