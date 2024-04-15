//
//  MapPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

final class MapPresenter {
    // MARK: - Properties
    weak var view: MapDisplayLogic?
}

// MARK: - PresentationLogic
extension MapPresenter: MapPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentParkingMap(_ response: Model.ParkingMap.Response) {
        let curDateStr = "\(response.startTime.prefix(10))"
        var curStartTimeStr = "\(response.startTime.suffix(8).prefix(5))"
        let curEndTimeStr = "\(response.endTime.suffix(8).prefix(5))"
        var notAvailableParkingSpots: [ParkingSpot]? = []
        var notFreeParkingSpots: [ParkingSpot]? = []
        var freeParkingSpotsForTime: [ParkingSpot]? = []
        var reservedParkingSpot: ParkingSpot?
        var hasReservationsForTime = false
        
        if let _ = response.reservations {
            hasReservationsForTime = true
        }
        
        for freeSpot in response.freeParkingSpotsForTime {
            if freeSpot.isAvailable == false {
                notAvailableParkingSpots?.append(freeSpot)
                continue
            }
            if freeSpot.isFree == true {
                freeParkingSpotsForTime?.append(freeSpot)
                continue
            }
            if let reservations = response.reservations {
                for reserve in reservations {
                    if freeSpot.id == reserve.parkingSpotId {
                        reservedParkingSpot = freeSpot
                        break
                    }
                }
            }
            if reservedParkingSpot == nil || freeSpot.id != reservedParkingSpot?.id {
                notFreeParkingSpots?.append(freeSpot)
            }
        }
        
        if let spots = notFreeParkingSpots, spots.isEmpty {
            notFreeParkingSpots = nil
        }
        
        if let spots = freeParkingSpotsForTime, spots.isEmpty {
            freeParkingSpotsForTime = nil
        }
        
        if let spots = notAvailableParkingSpots, spots.isEmpty {
            notAvailableParkingSpots = nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeDateFormatter = DateFormatter()
        timeDateFormatter.dateFormat = "HH:mm"
        
        let minStartTimeDate = timeDateFormatter.date(from: response.minimumStartTime) ?? Date()
        let minEndTimeDate = Calendar.current.date(byAdding: .minute, value: 30, to: timeDateFormatter.date(from: response.minimumStartTime) ?? Date()) ?? Date()
        let maxStartTimeDate = timeDateFormatter.date(from: "21:30") ?? Date()
        let maxEndTimeDate = timeDateFormatter.date(from: "22:00") ?? Date()
        let minDate = Date()
        let maxDate = Calendar.current.date(byAdding: .day, value: 30, to: dateFormatter.date(from: curDateStr) ?? Date()) ?? Date()
        let curDate = dateFormatter.date(from: curDateStr) ?? Date()
        var curStartTimeDate = timeDateFormatter.date(from: curStartTimeStr) ?? Date()
        let curEndTimeDate = timeDateFormatter.date(from: curEndTimeStr) ?? Date()
        
        if curStartTimeDate < minStartTimeDate {
            curStartTimeDate = minStartTimeDate
            curStartTimeStr = response.minimumStartTime
        }
        
        view?.displayParkingMap(MapModel.ParkingMap.ViewModel(notAvailableParkingSpots: notAvailableParkingSpots, notFreeParkingSpots: notFreeParkingSpots, freeParkingSpots: freeParkingSpotsForTime, reservedParkingSpot: reservedParkingSpot, parkingLevelCanvas: response.parkingLevelCanvas, curDateStr: curDateStr, curStartTimeStr: curStartTimeStr, curEndTimeStr: curEndTimeStr, buildingForDisplay: response.building, levelForDisplay: response.levelForDisplay, parkingLevels: response.parkingLevels, minStartTimeDate: minStartTimeDate, minEndTimeDate: minEndTimeDate, maxStartTimeDate: maxStartTimeDate, maxEndTimeDate: maxEndTimeDate, minDate: minDate, maxDate: maxDate, curDate: curDate, curStartTimeDate: curStartTimeDate, curEndTimeDate: curEndTimeDate, hasReservationsForTime: hasReservationsForTime))
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(MapModel.Home.ViewModel()     )
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(MapModel.More.ViewModel())
    }
    
    func presentPreviousScene(_ response: Model.PreviousScene.Response) {
        view?.displayPreviousScene(MapModel.PreviousScene.ViewModel())
    }
    
    func presentReloadedMap(_ response: Model.ReloadMap.Response) {
        var notAvailableParkingSpots: [ParkingSpot]? = []
        var notFreeParkingSpots: [ParkingSpot]? = []
        var freeParkingSpotsForTime: [ParkingSpot]? = []
        var reservedParkingSpot: ParkingSpot?
        var hasReservationsForTime = false
        
        if let _ = response.reservations {
            hasReservationsForTime = true
        }
        
        for freeSpot in response.freeParkingSpotsForTime {
            if freeSpot.isAvailable == false {
                notAvailableParkingSpots?.append(freeSpot)
                continue
            }
            if freeSpot.isFree == true {
                freeParkingSpotsForTime?.append(freeSpot)
                continue
            }
            if let reservations = response.reservations {
                for reserve in reservations {
                    if freeSpot.id == reserve.parkingSpotId {
                        reservedParkingSpot = freeSpot
                        break
                    }
                }
            }
            if reservedParkingSpot == nil || freeSpot.id != reservedParkingSpot?.id {
                notFreeParkingSpots?.append(freeSpot)
            }
        }
        
        if let spots = notFreeParkingSpots, spots.isEmpty {
            notFreeParkingSpots = nil
        }
        
        if let spots = freeParkingSpotsForTime, spots.isEmpty {
            freeParkingSpotsForTime = nil
        }
        
        if let spots = notAvailableParkingSpots, spots.isEmpty {
            notAvailableParkingSpots = nil
        }
        
        let timeDateFormatter = DateFormatter()
        timeDateFormatter.dateFormat = "HH:mm"
        
        let minStartTimeDate = timeDateFormatter.date(from: response.minimumStartTime) ?? Date()
        let minEndTimeDate = Calendar.current.date(byAdding: .minute, value: 30, to: timeDateFormatter.date(from: response.curStartTime) ?? Date()) ?? Date()
        
        var curEndTimeDate: Date?
        var curEndTimeStr: String?
        if let updatedCurEndTime = response.updatedCurEndTime {
            curEndTimeDate = timeDateFormatter.date(from: updatedCurEndTime) ?? Date()
            curEndTimeStr = response.updatedCurEndTime
        }
        
        view?.displayReloadedMap(MapModel.ReloadMap.ViewModel(notAvailableParkingSpots: notAvailableParkingSpots, notFreeParkingSpots: notFreeParkingSpots, freeParkingSpots: freeParkingSpotsForTime, reservedParkingSpot: reservedParkingSpot, parkingLevelCanvas: response.parkingLevelCanvas, minStartTimeDate: minStartTimeDate, minEndTimeDate: minEndTimeDate, curEndTimeDate: curEndTimeDate, curEndTimeStr: curEndTimeStr, hasReservationsForTime: hasReservationsForTime))
    }
    
    func presentReservationCard(_ response: Model.ReservationCard.Response) {
        self.view?.displayReservationCard(MapModel.ReservationCard.ViewModel(parkingSpotID: response.parkingSpotID, date: response.date, startTime: response.startTime, endTime: response.endTime, onUpdateAction: response.onUpdateAction, spotState: response.spotState))
    }
    
    func presentLoadingFailure(_ response: Model.LoadingFailure.Response) {
        view?.displayLoadingFailure(MapModel.LoadingFailure.ViewModel())
    }
    
    func presentReloadingFailure(_ response: Model.ReloadingFailure.Response) {
        view?.displayReloadingFailure(MapModel.ReloadingFailure.ViewModel())
    }
}
