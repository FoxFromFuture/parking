//
//  BuildingsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

public enum BuildingsApi {
    case getBuilding(buildingID: String)
    case getAllBuildings
    case getAllBuildingLevels(buildingID: String)
}

extension BuildingsApi: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://localhost:8080/building/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .getBuilding(let buildingID):
            return "\(buildingID)"
        case .getAllBuildings:
            return ""
        case .getAllBuildingLevels(let buildingID):
            return "\(buildingID)/levels"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getBuilding:
            return .get
        case .getAllBuildings:
            return .get
        case .getAllBuildingLevels:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getBuilding:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getAllBuildings:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getAllBuildingLevels:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(AuthManager().getAccessToken() ?? "")"]
    }
}
