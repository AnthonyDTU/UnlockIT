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
        
        DispatchQueue.main.async {
            self.finishedLoading = true
        }
    }
    
    func getAdministrators() -> [User] {
        return sort(sortAdmin: true)
    }
    
    func getNonAdministrators() -> [User] {
        return sort(sortAdmin: false)
    }
    
    private func sort(sortAdmin: Bool) -> [User] {
        
        var foundUsers: [User] = []
        for user in users {
            if sortAdmin && user.isAdmin { foundUsers.append(user) }
            else if !sortAdmin && !user.isAdmin { foundUsers.append(user) }
        }
        return foundUsers
    }
}
