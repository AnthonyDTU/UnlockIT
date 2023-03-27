//
//  KeyChainManager.swift
//  UnlockIT
//
//  Created by Anton Lage on 27/03/2023.
//

import Foundation


class KeychainManager {
    private let serviceName = "UnlockIT"
    
    enum KeychainError : Error {
        case noPassword
        case unexpectedPasswordData
        case encodingError
        case unkown(OSStatus)
    }
    
    
    func saveValue(account: String, data: Data) throws {
        let testQuery: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(testQuery as CFDictionary, &item)
        
        switch status {
        // If the copy operation was a success, the item already exists in keychain, and its value needs to be updated.
        case errSecSuccess:
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName as AnyObject,
                kSecAttrAccount as String: account as AnyObject,
                kSecValueData as String: data as AnyObject
            ]
            let updateStatus = SecItemAdd(query as CFDictionary, nil)
            guard updateStatus == errSecSuccess else { throw KeychainError.unkown(updateStatus)}
            
        // If the item was not found, it needs to be created in keychain
        case errSecItemNotFound:
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName as AnyObject,
                kSecAttrAccount as String: account as AnyObject,
                kSecValueData as String: data as AnyObject
            ]
            let saveStatus = SecItemAdd(query as CFDictionary, nil)
            guard saveStatus == errSecSuccess else { throw KeychainError.unkown(saveStatus)}
            
            
        default:
            throw KeychainError.unkown(status)
        }
    }
    
    func readValue(account: String) throws -> Data? {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeychainError.unkown(status) }
        return item as? Data
    }
}
