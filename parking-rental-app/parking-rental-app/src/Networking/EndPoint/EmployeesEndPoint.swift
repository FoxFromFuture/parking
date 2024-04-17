//
//  EmployeesEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import Foundation

public enum EmployeesApi {
    case deleteEmployee
    case updateEmployee(name: String, email: String, password: String)
}

extension EmployeesApi: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://127.0.0.1:8080/employees/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .deleteEmployee:
            return "employee"
        case .updateEmployee:
            return "employee"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .deleteEmployee:
            return .delete
        case .updateEmployee:
            return .put
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .deleteEmployee:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .updateEmployee(let name, let email, let password):
            return .requestParametersAndHeaders(bodyParameters: ["name": name, "email": email, "password": password], urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(AuthManager().getAccessToken() ?? "")"]
    }
}
