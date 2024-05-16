//
//  ParkingLevelsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

public enum ParkingLevelsApi {
    case getParkingLevel(parkingLevelID: String, accessToken: String)
    case getAllParkingLevels(accessToken: String)
    case getAllLevelSpots(parkingLevelID: String, accessToken: String)
    case getAllLevelFreeSpots(parkingLevelID: String, startTime: String, endTime: String, accessToken: String)
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
        case .getParkingLevel(let parkingLevelID, _):
            return "\(parkingLevelID)"
        case .getAllParkingLevels:
            return ""
        case .getAllLevelSpots(let parkingLevelID, _):
            return "\(parkingLevelID)/spots"
        case .getAllLevelFreeSpots(let parkingLevelID, _, _, _):
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
        case .getAllLevelFreeSpots(_, let startTime, let endTime, _):
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: ["startTime": startTime, "endTime": endTime], additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getParkingLevel(_, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getAllParkingLevels(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getAllLevelSpots(_, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getAllLevelFreeSpots(_, _, _, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        }
    }
}
