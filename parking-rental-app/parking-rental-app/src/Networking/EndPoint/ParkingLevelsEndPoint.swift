//
//  ParkingLevelsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

public enum ParkingLevelsApi {
    case getAllParkingLevels
    case getAllLevelSpots(parkingLevelID: String)
}

extension ParkingLevelsApi: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://localhost:8080/parkingLevels/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .getAllParkingLevels:
            return ""
        case .getAllLevelSpots(let parkingLevelID):
            return "\(parkingLevelID)/spots"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAllParkingLevels:
            return .get
        case .getAllLevelSpots:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getAllParkingLevels:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getAllLevelSpots:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(AuthManager.shared.getAccessToken() ?? "")"]
    }
}
