//
//  UserbaseViewModel.swift
//  UnlockIT
//
//  Created by Anton Lage on 06/03/2023.
//

import Foundation
import FirebaseDatabase

final class UserbaseViewModel : ObservableObject {
    @Published var users: [User] = []
    
    func loadExistingUsers() {
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
}
