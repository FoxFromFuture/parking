//
//  ParkingSpotsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

import Foundation

public enum ParkingSpotsApi {
    case getParkingSpot(parkingSpotID: String, accessToken: String)
    case getAllParkingSpots(accessToken: String)
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
        case .getParkingSpot(let parkingSpotID, _):
            return "\(parkingSpotID)"
        case .getAllParkingSpots:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getParkingSpot:
            return .get
        case .getAllParkingSpots:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getParkingSpot:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getAllParkingSpots:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getParkingSpot(_, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getAllParkingSpots(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        }
    }
}
