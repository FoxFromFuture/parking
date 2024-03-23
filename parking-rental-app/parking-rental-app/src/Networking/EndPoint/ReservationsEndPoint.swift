//
//  ReservationsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import Foundation

public enum ReservationsApi {
    case getAllReservations
    case addNewReservation(carId: String, employeeId: String, parkingSpotId: String, startTime: String, endTime: String)
    case deleteReservation(id: String)
}

extension ReservationsApi: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://localhost:8080/reservations/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .getAllReservations:
            return "employee"
        case .addNewReservation:
            return "employee"
        case .deleteReservation(let id):
            return "\(id)/employee"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAllReservations:
            return .get
        case .addNewReservation:
            return .post
        case .deleteReservation:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getAllReservations:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .addNewReservation(let carId, let employeeId, let parkingSpotId, let startTime, let endTime):
            return .requestParametersAndHeaders(bodyParameters: ["carId": carId, "employeeId": employeeId, "parkingSpotId": parkingSpotId, "startTime": startTime, "endTime": endTime], urlParameters: nil, additionHeaders: self.headers)
        case .deleteReservation:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(AuthManager.shared.getAccessToken() ?? "")"]
    }
}
