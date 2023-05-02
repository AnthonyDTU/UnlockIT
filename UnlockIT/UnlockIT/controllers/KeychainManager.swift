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
    
    /// Stores a value of type Data in the keychain. If a value for the given account already exists, it is overwritten with the new data
    /// - Parameters:
    ///   - account: The account tag for the data
    ///   - data: The data
    func storeValue(key: String, data: Data) throws {
        let testQuery: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName as AnyObject,
            kSecAttrAccount as String: key as AnyObject,
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
                kSecAttrAccount as String: key as AnyObject,
                kSecValueData as String: data as AnyObject
            ]
            
            var updatedValues = [String: AnyObject]()
            updatedValues[kSecValueData as String] = data as AnyObject
            
            let updateStatus = SecItemUpdate(query as CFDictionary, updatedValues as CFDictionary)
            //let updateStatus = SecItemAdd(query as CFDictionary, nil)
            guard updateStatus == errSecSuccess else { throw KeychainError.unkown(updateStatus)}
            return
            
        // If the item was not found, it needs to be created in keychain
        case errSecItemNotFound:
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName as AnyObject,
                kSecAttrAccount as String: key as AnyObject,
                kSecValueData as String: data as AnyObject
            ]
            let saveStatus = SecItemAdd(query as CFDictionary, nil)
            guard saveStatus == errSecSuccess else { throw KeychainError.unkown(saveStatus)}
            return
            
            
        default:
            throw KeychainError.unkown(status)
        }
    }
    
    
    /// Fetches a value of type Data from the keychain
    /// - Parameter account: The account tag of the data
    /// - Returns: The fetched data or nil
    func fetchValue(key: String) throws -> Data? {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName as AnyObject,
            kSecAttrAccount as String: key as AnyObject,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeychainError.unkown(status) }
        return item as? Data
    }
}
