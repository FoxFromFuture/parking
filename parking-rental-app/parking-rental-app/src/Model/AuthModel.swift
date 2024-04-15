//
//  AuthModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/21/24.
//

import Foundation

struct AuthApiResponse: Decodable {
    let type: String
    let accessToken: String
    let refreshToken: String
}

struct AuthApiAccessTokenResponse: Decodable {
    let type: String
    let accessToken: String
    let refreshToken: String?
}

struct AuthWhoamiApiResponse: Decodable {
    let id: String
    let email: String
    let name: String
    let roles: [String]
    let principal: Principal
}

struct Principal: Decodable { }
