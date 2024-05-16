//
//  KeychainManager.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import Foundation

protocol KeychainManagerProtocol {
    func save(key: String, data: Data) throws
    func get(key: String) throws -> Data?
    func delete(key: String) throws
    func update(key: String, data: Data) throws
}

enum KeychainError: Error {
    case unknown(status: OSStatus)
}

enum KeychainKeys: String {
    case service = "parking-rental-app"
}

final class KeychainManager: KeychainManagerProtocol {
    func save(key: String, data: Data) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: KeychainKeys.service.rawValue,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
    }
    
    func get(key: String) throws -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: KeychainKeys.service.rawValue,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        
        return result as? Data
    }
    
    func delete(key: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: KeychainKeys.service.rawValue,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
    }
    
    func update(key: String, data: Data) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: KeychainKeys.service.rawValue,
            kSecAttrAccount: key
        ]
        
        let newData: [CFString: Any] = [
            kSecValueData: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, newData as CFDictionary)

        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
    }
}
