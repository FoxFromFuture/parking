//
//  MapModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

enum MapModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Home {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum More {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum PreviousScene {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum ParkingMap {
        struct Request {
            let initBuildingID: String?
            let initReservationID: String?
        }
        struct Response {
            let freeParkingSpotsForTime: [ParkingSpot]
            let reservations: [Reservation]?
            let parkingLevelCanvas: Canvas
            let parkingLevels: [ParkingLevel]
            let startTime: Date
            let endTime: Date
            let building: Building
            let levelForDisplay: ParkingLevel
            let minStartTime: Date
        }
        struct ViewModel {
            let notAvailableParkingSpots: [ParkingSpot]?
            let notFreeParkingSpots: [ParkingSpot]?
            let freeParkingSpots: [ParkingSpot]?
            let reservedParkingSpot: ParkingSpot?
            let parkingLevelCanvas: Canvas
            let buildingForDisplay: Building
            let levelForDisplay: ParkingLevel
            let parkingLevels: [ParkingLevel]
            let minStartTimeDate: Date
            let minEndTimeDate: Date
            let maxStartTimeDate: Date
            let maxEndTimeDate: Date
            let minDate: Date
            let maxDate: Date
            let curDate: Date
            let curStartTimeDate: Date
            let curEndTimeDate: Date
        }
    }
    
    enum ReloadMap {
        struct Request {
            let floorID: String
            let date: Date
            let startTime: Date
            let endTime: Date
        }
        struct Response {
            let freeParkingSpotsForTime: [ParkingSpot]
            let reservations: [Reservation]?
            let parkingLevelCanvas: Canvas
            let minStartTime: Date
            let minEndTime: Date
            let curEndTime: Date?
        }
        struct ViewModel {
            let notAvailableParkingSpots: [ParkingSpot]?
            let notFreeParkingSpots: [ParkingSpot]?
            let freeParkingSpots: [ParkingSpot]?
            let reservedParkingSpot: ParkingSpot?
            let parkingLevelCanvas: Canvas
            let minStartTimeDate: Date
            let minEndTimeDate: Date
            let curEndTimeDate: Date?
        }
    }
    
    enum ReservationCard {
        struct Request {
            let parkingSpotID: String
            let date: Date
            let startTime: Date
            let endTime: Date
            let onUpdateAction: (() -> Void)
            let spotState: ReservationCardSpotState
        }
        struct Response {
            let parkingSpotID: String
            let date: Date
            let startTime: Date
            let endTime: Date
            let onUpdateAction: (() -> Void)
            let spotState: ReservationCardSpotState
        }
        struct ViewModel {
            let parkingSpotID: String
            let date: Date
            let startTime: Date
            let endTime: Date
            let onUpdateAction: (() -> Void)
            let spotState: ReservationCardSpotState
        }
        struct RouteData {
            let parkingSpotID: String
            let date: Date
            let startTime: Date
            let endTime: Date
            let onUpdateAction: (() -> Void)
            let spotState: ReservationCardSpotState
        }
    }
    
    enum LoadingFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum ReloadingFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
