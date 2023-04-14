//
//  StringExtensions.swift
//  UnlockIT
//
//  Created by Anton Lage on 14/04/2023.
//

import Foundation

// https://www.hackingwithswift.com/example-code/language/how-to-throw-errors-using-strings
extension String : LocalizedError {
    public var errorDescription: String? { return self }
}
