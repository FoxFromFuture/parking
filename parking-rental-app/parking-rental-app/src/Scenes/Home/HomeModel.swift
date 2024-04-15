//
//  HomeModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

enum HomeModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum GetReservations {
        struct Request { }
        struct Response {
            let reservations: [Reservation]
            let parkingSpots: [ParkingSpot]
            let parkingLevels: [ParkingLevel]
            let buildings: [Building]
        }
        struct ViewModel {
            let reservationsCount: Int
            let dates: [String]
            let startTimes: [String]
            let endTimes: [String]
            let lotNumbets: [String]
            let levelNumbers: [String]
            let buildingNames: [String]
            let reservationsIDx: [String]
            let isReservationsLimit: Bool
        }
    }
    
    enum Buildings {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Map {
        struct Request {
            let reservationID: String
        }
        struct Response {
            let reservationID: String
        }
        struct ViewModel {
            let reservationID: String
        }
        struct RouteData {
            let reservationID: String
        }
    }
    
    enum Profile {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum More {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum LoadingFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum NoData {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
