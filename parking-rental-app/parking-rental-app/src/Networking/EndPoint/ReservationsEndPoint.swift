//
//  ReservationsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import Foundation

public enum ReservationsApi {
    case getAllReservations(accessToken: String)
    case addNewReservation(carId: String, employeeId: String, parkingSpotId: String, startTime: String, endTime: String, accessToken: String)
    case deleteReservation(id: String, accessToken: String)
    case getReservation(reservationID: String, accessToken: String)
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
        case .deleteReservation(let id, _):
            return "\(id)/employee"
        case .getReservation(let reservationID, _):
            return "\(reservationID)"
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
        case .getReservation:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getAllReservations:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .addNewReservation(let carId, let employeeId, let parkingSpotId, let startTime, let endTime, _):
            return .requestParametersAndHeaders(bodyParameters: ["carId": carId, "employeeId": employeeId, "parkingSpotId": parkingSpotId, "startTime": startTime, "endTime": endTime], urlParameters: nil, additionHeaders: self.headers)
        case .deleteReservation:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getReservation:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getAllReservations(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .addNewReservation(_, _, _, _, _, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .deleteReservation(_, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getReservation(_, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        }
    }
}
