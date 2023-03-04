//
//  Unlockable.swift
//  UnlockIT
//
//  Created by Anton Lage on 03/03/2023.
//

import Foundation

class Collection {
    
    var id: Int = 0
    var name: String = ""
    var owner: User?
    var subscribers: [User]?
    var collection: String = ""
    var unlockables: [Unlockable]?
    var joinCode: String = ""
    var calendar: [Unlockable]? // Only bookable unlockables
    
    
    
    
    
    
}


class Subscription {
    var id: Int = 0
    var name: String = ""
    var key: String = ""
}




protocol Unlockable {
    var id: Int { get }
    var name: String { get }
    var locks: [myLock] { get }
    var isBookable: Bool { get }
    var needsBooking: Bool { get }
    
    func unlock() -> Bool
    func book() -> Bool
    
    
    
}

class myLock {
    
    var interface: String = "" // NFC, Bluetooth, WiFi .. etc.
    var code: String = ""
    
}
