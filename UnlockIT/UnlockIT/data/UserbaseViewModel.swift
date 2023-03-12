//
//  UserbaseViewModel.swift
//  UnlockIT
//
//  Created by Anton Lage on 06/03/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

final class UserbaseViewModel : ObservableObject {
    @Published var users: [User] = []
    @Published var finishedLoading: Bool = false
    
    func loadExistingUsers() {
        users.removeAll()
        let databaseRef = Database.database().reference()
        databaseRef.child("Users").observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [String : [String : Any]]{
                
                for item in data {
                    let user = User()
                    user.configureUserData(userID: item.key, data: item.value)
                    self.users.append(user)
                }
            }
        })
    }
    
    func loadExistingUsersFromFirestore() async throws {
        
        DispatchQueue.main.async {
            self.users.removeAll()
            self.finishedLoading = false
        }

        let myCompany = "DTU"
        let firestore = Firestore.firestore()
        let collectionSnapshot = try await firestore.collection("Companies").document(myCompany).collection("Users").getDocuments()
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
}
