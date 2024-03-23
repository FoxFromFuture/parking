//
//  AuthModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/21/24.
//

import Foundation

struct AuthApiResponse {
    let type: String
    let accessToken: String
    let refreshToken: String
}

extension AuthApiResponse: Decodable {
    enum AuthCodingKeys: String, CodingKey {
        case type
        case accessToken
        case refreshToken
    }
    
    init(from decoder: Decoder) throws {
        let authContainer = try decoder.container(keyedBy: AuthCodingKeys.self)
        type = try authContainer.decode(String.self, forKey: .type)
        accessToken = try authContainer.decode(String.self, forKey: .accessToken)
        refreshToken = try authContainer.decode(String.self, forKey: .refreshToken)
    }
}

struct AuthApiAccessTokenResponse {
    let type: String
    let accessToken: String
    let refreshToken: String?
}

extension AuthApiAccessTokenResponse: Decodable {
    enum AuthApiAccessTokenCodingKeys: String, CodingKey {
        case type
        case accessToken
        case refreshToken
    }
    
    init(from decoder: Decoder) throws {
        let authContainer = try decoder.container(keyedBy: AuthApiAccessTokenCodingKeys.self)
        type = try authContainer.decode(String.self, forKey: .type)
        accessToken = try authContainer.decode(String.self, forKey: .accessToken)
        refreshToken = nil
    }
}

struct AuthWhoamiApiResponse {
    let id: String
    let email: String
    let name: String
    let roles: [String]
    let principal: Principal
}

extension AuthWhoamiApiResponse: Decodable {
    enum AuthWhoamiCodingKeys: String, CodingKey {
        case id
        case email
        case name
        case roles
        case principal
    }
    
    init(from decoder: Decoder) throws {
        let authWhoamiContainer = try decoder.container(keyedBy: AuthWhoamiCodingKeys.self)
        id = try authWhoamiContainer.decode(String.self, forKey: .id)
        email = try authWhoamiContainer.decode(String.self, forKey: .email)
        name = try authWhoamiContainer.decode(String.self, forKey: .name)
        roles = try authWhoamiContainer.decode([String].self, forKey: .roles)
        principal = try authWhoamiContainer.decode(Principal.self, forKey: .principal)
    }
}

struct Principal { }

extension Principal: Decodable {
    init(from decoder: Decoder) throws { }
}
