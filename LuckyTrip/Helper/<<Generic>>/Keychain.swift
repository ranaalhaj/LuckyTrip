//
//  Keychain.swift
//
//  Created by Rana Alhaj on 14/8/22.
//  Copyright © 2022 ranaalhaj. All rights reserved.
//

import Foundation

import Security

/// Save important and sensitve keys in iPhone keychain
///
/// This class provides four class functions for use
/// - ``Save`` : It will encrypt your data (binary) and store it in keychain using key (String), and classify it based on (Class) usually it uses GenericPassword class
/// - ``Load`` : used to retrive encrypted content from keychain using key (String) and decrypt it to data(Binary)
/// - ``delete`` function to generate UUID
/// - ``createUniqueID`` function to generate UUID

class KeyChain {
    
    /// - Parameter key : unique key used to refer to your data in keychain, prefered to use app bundle as prefix
    /// - Parameter data : the data that you are going to store in keychain
    @discardableResult
    class func save(key: String, data: Data, `class` : String = kSecClassGenericPassword as String) -> OSStatus {
        let query = [
            kSecClass as String       : `class`,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }
    
    /// - Parameter key : unique key used to refer to your data in keychain, prefered to use app bundle as prefix
    /// - Parameter data : the data that you are going to store in keychain
    class func load(key: String, `class` : String = kSecClassGenericPassword as String) -> Data? {
        let query = [
            kSecClass as String       : `class`,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    @discardableResult
    class func delete(key: String, `class` : String = kSecClassGenericPassword as String) -> OSStatus {
        let query = [
            kSecClass as String       : `class`,
            kSecAttrAccount as String : key] as [String : Any]

        return SecItemDelete(query as CFDictionary)
    }


    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
}


