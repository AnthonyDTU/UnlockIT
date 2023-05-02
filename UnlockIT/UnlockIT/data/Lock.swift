//
//  Lock.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 27/02/2023.
//

import Foundation

struct Lock: Identifiable, Codable, Equatable, Hashable{
    var id: UUID = UUID()
    var description: String = "Lock Description"
    var lockId: Int = 1
    var authenticationLevel : Int = 1
    var lastUnlock : Date = NSDate(timeIntervalSinceNow: -10000) as Date
    
    static func == (lhs: Lock, rhs: Lock) -> Bool {
        //Should be sufficient due to the uniqueness of UUID
        return lhs.id == rhs.id
    }
}
