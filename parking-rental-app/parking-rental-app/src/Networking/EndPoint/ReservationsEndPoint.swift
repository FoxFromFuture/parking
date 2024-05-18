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
    case getReservation(reservationID: String)
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
        case .getReservation(let reservationID):
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
            return .request
        case .addNewReservation(let carId, let employeeId, let parkingSpotId, let startTime, let endTime):
            return .requestParameters(bodyParameters: ["carId": carId, "employeeId": employeeId, "parkingSpotId": parkingSpotId, "startTime": startTime, "endTime": endTime], urlParameters: nil)
        case .deleteReservation:
            return .request
        case .getReservation:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
