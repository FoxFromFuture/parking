//
//  AuthManager.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() { }
    
    enum TokenType: String {
        case access = "access-token"
        case refresh = "refresh-token"
    }
    
    public func getRefreshToken() -> String? {
        do {
            guard let refreshToken = try KeychainManager.get(key: "refresh-token") else { return nil }
            return String(decoding: refreshToken, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    public func getAccessToken() -> String? {
        do {
            guard let accessToken = try KeychainManager.get(key: "access-token") else { return nil }
            return String(decoding: accessToken, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    @discardableResult
    public func saveTokens(refreshToken: String, accessToken: String) -> Bool {
        do {
            try KeychainManager.save(key: "refresh-token", data: refreshToken.data(using: .utf8) ?? Data())
            try KeychainManager.save(key: "access-token", data: accessToken.data(using: .utf8) ?? Data())
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
    
    public func updateToken(token: String, tokenType: TokenType) -> Bool {
        do {
            try KeychainManager.update(key: tokenType.rawValue, data: token.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }
    
    public func deleteToken(token: String, tokenType: TokenType) -> Bool {
        do {
            try KeychainManager.delete(key: tokenType.rawValue, data: token.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }
}
