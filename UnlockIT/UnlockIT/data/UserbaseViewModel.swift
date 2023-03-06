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
    
    private lazy var databasePath: DatabaseReference? = {
        let ref = Database.database().reference().child("Users")
        return ref
    }()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func loadExistingUsers() {
        databasePath?.observeSingleEvent(of: .value, with: { snapshot in
            
            if let data = snapshot.value as? [String : [String : Any]] {
                
                do {
                    for json in data {
                        let userData = try JSONSerialization.data(withJSONObject: json)
                        let user = try self.decoder.decode(User.self, from: userData)
                        self.users.append(user)
                    }
                }
                catch {
                    print("an error occoured", error)
                }
            }
        })
    }
    
    func listenToUserDatabase() {
        guard let databasePath = databasePath else {
            return
        }
        
        databasePath.observe(.childAdded) { [weak self] snapshot in
            guard
                let self = self,
                var json = snapshot.value as? [String: Any]
            else {
                return
            }
            json["id"] = snapshot.key
            do {
                let userData = try JSONSerialization.data(withJSONObject: json)
                let user = try self.decoder.decode(User.self, from: userData)
                self.users.append(user)
            } catch {
                print("an error occurred", error)
            }
        }
    }
    
    func stopListening() {
        databasePath?.removeAllObservers()
    }
}
