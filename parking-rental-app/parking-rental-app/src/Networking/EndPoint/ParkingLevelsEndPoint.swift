//
//  ParkingLevelsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

public enum ParkingLevelsApi {
    case getParkingLevel(parkingLevelID: String)
    case getAllParkingLevels
    case getAllLevelSpots(parkingLevelID: String)
    case getAllLevelFreeSpots(parkingLevelID: String, startTime: String, endTime: String)
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
        case .getParkingLevel(let parkingLevelID):
            return "\(parkingLevelID)"
        case .getAllParkingLevels:
            return ""
        case .getAllLevelSpots(let parkingLevelID):
            return "\(parkingLevelID)/spots"
        case .getAllLevelFreeSpots(let parkingLevelID, _, _):
            return "\(parkingLevelID)/freeSpotsInInterval"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getParkingLevel:
            return .get
        case .getAllParkingLevels:
            return .get
        case .getAllLevelSpots:
            return .get
        case .getAllLevelFreeSpots:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getParkingLevel:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getAllParkingLevels:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getAllLevelSpots:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getAllLevelFreeSpots(_, let startTime, let endTime):
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: ["startTime": startTime, "endTime": endTime], additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(AuthManager().getAccessToken() ?? "")"]
    }
}
