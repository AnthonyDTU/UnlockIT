//
//  BoolExtensions.swift
//  UnlockIT
//
//  Created by Anton Lage on 14/04/2023.
//

import Foundation

// XOR operator
extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}
