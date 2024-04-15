//
//  ReservationsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import Foundation

struct Reservation: Decodable {
    let id: String
    let carId: String
    let employeeId: String
    let parkingSpotId: String
    let startTime: String
    let endTime: String
}
