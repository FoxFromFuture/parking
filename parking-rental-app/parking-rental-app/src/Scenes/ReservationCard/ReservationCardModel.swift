//
//  ReservationCardModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/5/24.
//

import UIKit

enum ReservationCardModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum ReservationCardInfo {
        struct Request {
            let parkingSpotID: String
            let spotState: ReservationCardSpotState
            let date: Date
            let startTime: Date
            let endTime: Date
        }
        struct Response {
            let parkingSpot: ParkingSpot
            let car: Car
            let reservationID: String?
            let reservationStartTime: String?
            let reservationEndTime: String?
            let reservationsLimitForTime: Bool
            let reservationsLimit: Bool
            let weekendLimit: Bool
            let startTime: Date
            let endTime: Date
        }
        struct ViewModel {
            let parkingLotNumber: String
            let carID: String
            let carRegistryNumber: String
            let employeeID: String
            let reservationID: String?
            let reservationsLimitForTime: Bool
            let reservationsLimit: Bool
            let weekendLimit: Bool
            let startTime: String
            let endTime: String
            let date: String
        }
    }
    
    enum CreateReservation {
        struct Request {
            let employeeID: String
            let carID: String
            let parkingSpotID: String
            let date: Date
            let startTime: Date
            let endTime: Date
        }
        struct Response {
            let reservationID: String
        }
        struct ViewModel {
            let reservationID: String
        }
    }
    
    enum CancelReservation {
        struct Request {
            let reservationID: String
        }
        struct Response { }
        struct ViewModel { }
    }
    
    enum LoadingFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
