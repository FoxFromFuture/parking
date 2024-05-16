//
//  MockKeychainManager.swift
//  parking-rental-app-Tests
//
//  Created by Никита Лисунов on 5/16/24.
//

import Foundation
@testable import parking_rental_app

final class MockKeychainManager: KeychainManagerProtocol {
    
    private var dict = [String: Data]()
    
    func save(key: String, data: Data) throws {
        dict[key] = data
    }
    
    func get(key: String) throws -> Data? {
        return dict[key]
    }
    
    func delete(key: String) throws {
        dict[key] = nil
    }
    
    func update(key: String, data: Data) throws {
        dict[key] = data
    }
}
