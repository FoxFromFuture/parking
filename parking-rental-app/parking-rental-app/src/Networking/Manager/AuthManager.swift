//
//  AuthManager.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import Foundation

public enum AuthManagerTokenType: String {
    case access = "access-token"
    case refresh = "refresh-token"
}

public protocol AuthManagerProtocol {
    func getRefreshToken() -> String?
    func getAccessToken() -> String?
    func saveTokens(refreshToken: String, accessToken: String) -> Bool
    func saveToken(token: String, tokenType: AuthManagerTokenType) -> Bool
    func updateToken(token: String, tokenType: AuthManagerTokenType) -> Bool
    func deleteToken(tokenType: AuthManagerTokenType) -> Bool
    func getRefreshTokenLastUpdateDate() -> Date?
    func setRefreshTokenLastUpdateDate(date: Date)
    func deleteRefreshTokenLastUpdateDate()
}

final class AuthManager: AuthManagerProtocol {
    
    private var storage: UserDefaultsServiceProtocol!
    private var keychain: KeychainManagerProtocol!
    
    init(storage: UserDefaultsServiceProtocol = UserDefaultsService(), keychain: KeychainManagerProtocol = KeychainManager()) {
        self.storage = storage
        self.keychain = keychain
    }
    
    public func getRefreshToken() -> String? {
        do {
            guard let refreshToken = try keychain.get(key: AuthManagerTokenType.refresh.rawValue) else { return nil }
            return String(decoding: refreshToken, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    public func getAccessToken() -> String? {
        do {
            guard let accessToken = try keychain.get(key: AuthManagerTokenType.access.rawValue) else { return nil }
            return String(decoding: accessToken, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    @discardableResult
    public func saveTokens(refreshToken: String, accessToken: String) -> Bool {
        do {
            try keychain.save(key: AuthManagerTokenType.refresh.rawValue, data: refreshToken.data(using: .utf8) ?? Data())
            try keychain.save(key: AuthManagerTokenType.access.rawValue, data: accessToken.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func saveToken(token: String, tokenType: AuthManagerTokenType) -> Bool {
        do {
            try keychain.save(key: tokenType.rawValue, data: token.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func updateToken(token: String, tokenType: AuthManagerTokenType) -> Bool {
        do {
            try keychain.update(key: tokenType.rawValue, data: token.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func deleteToken(tokenType: AuthManagerTokenType) -> Bool {
        do {
            try keychain.delete(key: tokenType.rawValue)
            return true
        } catch {
            return false
        }
    }
    
    public func getRefreshTokenLastUpdateDate() -> Date? {
        return storage.date
    }
    
    public func setRefreshTokenLastUpdateDate(date: Date) {
        storage.date = date
    }
    
    public func deleteRefreshTokenLastUpdateDate() {
        storage.date = nil
    }
}
