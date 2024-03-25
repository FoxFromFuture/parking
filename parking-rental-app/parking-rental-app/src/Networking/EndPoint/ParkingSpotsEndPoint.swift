//
//  ParkingSpotsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

import Foundation

public enum ParkingSpotsApi {
    case getAllParkingSpots
}

extension ParkingSpotsApi: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://localhost:8080/parkingSpots/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .getAllParkingSpots:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAllParkingSpots:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getAllParkingSpots:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(AuthManager.shared.getAccessToken() ?? "")"]
    }
}
