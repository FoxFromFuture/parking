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
            return .request
        case .getAllParkingLevels:
            return .request
        case .getAllLevelSpots:
            return .request
        case .getAllLevelFreeSpots(_, let startTime, let endTime):
            return .requestParameters(bodyParameters: nil, urlParameters: ["startTime": startTime, "endTime": endTime])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
