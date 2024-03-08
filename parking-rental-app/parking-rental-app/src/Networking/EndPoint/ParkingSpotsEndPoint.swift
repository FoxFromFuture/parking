//
//  ParkingSpotsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

import Foundation

public enum ParkingSpotsApi {
    case getParkingSpotInfo(id: String)
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
        case .getParkingSpotInfo(let id):
            return "\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getParkingSpotInfo:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getParkingSpotInfo:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(AuthManager.shared.getAccessToken() ?? "")"]
    }
}
