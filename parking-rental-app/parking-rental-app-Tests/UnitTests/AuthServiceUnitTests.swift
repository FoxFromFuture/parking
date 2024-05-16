//
//  AuthServiceUnitTests.swift
//  parking-rental-app-Tests
//
//  Created by Никита Лисунов on 5/15/24.
//

import XCTest
@testable import parking_rental_app

final class AuthServiceUnitTests: XCTestCase {
    
    var authManager: AuthManager!
    var storage: UserDefaultsServiceProtocol!
    var keychain: KeychainManagerProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        storage = UserDefaultsService(userDefaultsContainer: MockUserDefaultsContainer())
        keychain = MockKeychainManager()
        authManager = AuthManager(storage: storage, keychain: keychain)
    }

    override func tearDownWithError() throws {
        authManager = nil
        try super.tearDownWithError()
    }

    func testGetAccessToken() throws {
        // Arrange
        let accessToken = "some"
        try keychain.save(key: AuthManagerTokenType.access.rawValue, data: accessToken.data(using: .utf8) ?? Data())
        
        // Act
        let result = authManager.getAccessToken()
        
        // Assert
        XCTAssertEqual(accessToken, result)
    }
    
    func testGetRefreshToken() throws {
        // Arrange
        let refreshToken = "some"
        try keychain.save(key: AuthManagerTokenType.refresh.rawValue, data: refreshToken.data(using: .utf8) ?? Data())
        
        // Act
        let result = authManager.getRefreshToken()
        
        // Assert
        XCTAssertEqual(refreshToken, result)
    }
    
    func testSaveToken() throws {
        // Arrange
        let accessToken = "some"
        try keychain.delete(key: AuthManagerTokenType.access.rawValue)
        
        // Act
        let result = authManager.saveToken(token: accessToken, tokenType: .access)
        
        // Assert
        XCTAssertTrue(result)
        let savedToken = try keychain.get(key: AuthManagerTokenType.access.rawValue)
        XCTAssertNotNil(savedToken)
        XCTAssertEqual(String(decoding: savedToken!, as: UTF8.self), accessToken)
    }
    
    func testSaveTokens() throws {
        // Arrange
        let accesToken = "access"
        let refreshToken = "refresh"
        
        // Act
        let accessResult = authManager.saveToken(token: accesToken, tokenType: .access)
        let refreshResult = authManager.saveToken(token: refreshToken, tokenType: .refresh)
        
        // Assert
        XCTAssertTrue(accessResult)
        XCTAssertTrue(refreshResult)
        let accessSavedToken = try keychain.get(key: AuthManagerTokenType.access.rawValue)
        let refreshSavedToken = try keychain.get(key: AuthManagerTokenType.refresh.rawValue)
        XCTAssertNotNil(accessSavedToken)
        XCTAssertNotNil(refreshSavedToken)
        XCTAssertEqual(String(decoding: accessSavedToken!, as: UTF8.self), accesToken)
        XCTAssertEqual(String(decoding: refreshSavedToken!, as: UTF8.self), refreshToken)
    }
    
    func testUpdateToken() throws {
        // Arrange
        let oldRefreshToken = "some"
        let newRefreshToken = "bone"
        try keychain.save(key: AuthManagerTokenType.refresh.rawValue, data: oldRefreshToken.data(using: .utf8) ?? Data())
        
        // Act
        let updateResult = authManager.updateToken(token: newRefreshToken, tokenType: .refresh)
        
        // Assert
        XCTAssertTrue(updateResult)
        let result = try keychain.get(key: AuthManagerTokenType.refresh.rawValue)
        XCTAssertNotNil(result)
        XCTAssertEqual(String(decoding: result!, as: UTF8.self), newRefreshToken)
    }
    
    func testDeleteToken() throws {
        // Arrange
        let accessToken = "some"
        try keychain.save(key: AuthManagerTokenType.access.rawValue, data: accessToken.data(using: .utf8) ?? Data())
        
        // Act
        let result = authManager.deleteToken(tokenType: .access)
        
        // Assert
        XCTAssertTrue(result)
        let deletedToken = try keychain.get(key: AuthManagerTokenType.access.rawValue)
        XCTAssertEqual(deletedToken, nil)
    }
    
    func testGetRefreshTokenLastUpdateDate() throws {
        // Arrange
        let date = Date()
        storage.date = date
        
        // Act
        let result = authManager.getRefreshTokenLastUpdateDate()
        
        // Assert
        XCTAssertEqual(result, date)
    }
    
    func testSetRefreshTokenLastUpdateDate() throws {
        // Arrange
        let date = Date()
        storage.date = nil
        
        // Act
        authManager.setRefreshTokenLastUpdateDate(date: date)
        
        // Assert
        XCTAssertEqual(storage.date, date)
    }
    
    func testDeleteRefreshTokenLastUpdateDate() throws {
        // Arrange
        let date = Date()
        storage.date = date
        
        // Act
        authManager.deleteRefreshTokenLastUpdateDate()
        
        // Assert
        XCTAssertEqual(storage.date, nil)
    }
}
