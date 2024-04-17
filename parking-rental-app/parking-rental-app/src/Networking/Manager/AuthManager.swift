//
//  AuthManager.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import Foundation

final class AuthManager {

    enum TokenType: String {
        case access = "access-token"
        case refresh = "refresh-token"
    }
    
    public func getRefreshToken() -> String? {
        do {
            guard let refreshToken = try KeychainManager.get(key: TokenType.refresh.rawValue) else { return nil }
            return String(decoding: refreshToken, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    public func getAccessToken() -> String? {
        do {
            guard let accessToken = try KeychainManager.get(key: TokenType.access.rawValue) else { return nil }
            return String(decoding: accessToken, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    @discardableResult
    public func saveTokens(refreshToken: String, accessToken: String) -> Bool {
        do {
            try KeychainManager.save(key: TokenType.refresh.rawValue, data: refreshToken.data(using: .utf8) ?? Data())
            try KeychainManager.save(key: TokenType.access.rawValue, data: accessToken.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func saveToken(token: String, tokenType: TokenType) -> Bool {
        do {
            try KeychainManager.save(key: tokenType.rawValue, data: token.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func updateToken(token: String, tokenType: TokenType) -> Bool {
        do {
            try KeychainManager.update(key: tokenType.rawValue, data: token.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    public func deleteToken(tokenType: TokenType) -> Bool {
        do {
            try KeychainManager.delete(key: tokenType.rawValue)
            return true
        } catch {
            return false
        }
    }
    
    public func getRefreshTokenLastUpdateDate() -> Date? {
        return UserDefaults.standard.object(forKey: "refreshTokenLastUpdateDate") as? Date
    }
    
    public func setRefreshTokenLastUpdateDate(date: Date) {
        UserDefaults.standard.set(date, forKey: "refreshTokenLastUpdateDate")
    }
    
    public func deleteRefreshTokenLastUpdateDate() {
        UserDefaults.standard.removeObject(forKey: "refreshTokenLastUpdateDate")
    }
}
