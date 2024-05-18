//
//  AuthEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/21/24.
//

import Foundation

public enum AuthApi {
    case whoami
    case login(email: String, password: String)
    case signUp(name: String, email: String, password: String)
    case updateAccessToken(refreshToken: String)
    case updateRefreshToken(refreshToken: String)
}

extension AuthApi: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://127.0.0.1:8080/auth/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .whoami:
            return "whoami"
        case .login:
            return "login"
        case .signUp:
            return "signUp"
        case .updateAccessToken:
            return "update/access"
        case .updateRefreshToken:
            return "update/refresh"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .whoami:
            return .get
        case .login:
            return .post
        case .signUp:
            return .post
        case .updateAccessToken:
            return .post
        case .updateRefreshToken:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .whoami:
            return .request
        case .login(let email, let password):
            return .requestParameters(bodyParameters: ["email": email, "password": password], urlParameters: nil)
        case .signUp(let name, let email, let password):
            return .requestParameters(bodyParameters: ["name": name, "email": email, "password": password, "roles": ["APP_USER"]], urlParameters: nil)
        case .updateAccessToken(let refreshToken):
            return .requestParameters(bodyParameters: ["refreshToken": refreshToken], urlParameters: nil)
        case .updateRefreshToken(let refreshToken):
            return .requestParameters(bodyParameters: ["refreshToken": refreshToken], urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
