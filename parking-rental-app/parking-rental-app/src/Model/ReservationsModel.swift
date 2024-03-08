//
//  ReservationsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import Foundation

struct Reservation {
    let id: String
    let carId: String
    let employeeId: String
    let parkingSpotId: String
    let startTime: String
    let endTime: String
}

extension Reservation: Decodable {
    enum ReservationCodingKeys: String, CodingKey {
        case id
        case carId
        case employeeId
        case parkingSpotId
        case startTime
        case endTime
    }
    
    init(from decoder: Decoder) throws {
        let reservationContainer = try decoder.container(keyedBy: ReservationCodingKeys.self)
        id = try reservationContainer.decode(String.self, forKey: .id)
        carId = try reservationContainer.decode(String.self, forKey: .carId)
        employeeId = try reservationContainer.decode(String.self, forKey: .employeeId)
        parkingSpotId = try reservationContainer.decode(String.self, forKey: .parkingSpotId)
        startTime = try reservationContainer.decode(String.self, forKey: .startTime)
        endTime = try reservationContainer.decode(String.self, forKey: .endTime)
    }
}
