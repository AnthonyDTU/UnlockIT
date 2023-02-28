//
//  Lock.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 27/02/2023.
//

import Foundation

struct Lock: Identifiable{
    var id: String;
    var authenticationLevel : Int;
    var lastUnlock : NSDate;
    
}
