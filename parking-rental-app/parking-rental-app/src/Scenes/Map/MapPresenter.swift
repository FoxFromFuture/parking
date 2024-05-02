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
    private var calendar = Calendar(identifier: .gregorian)
}

// MARK: - PresentationLogic
extension MapPresenter: MapPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentParkingMap(_ response: Model.ParkingMap.Response) {
        var notAvailableParkingSpots: [ParkingSpot]? = []
        var notFreeParkingSpots: [ParkingSpot]? = []
        var freeParkingSpotsForTime: [ParkingSpot]? = []
        var reservedParkingSpot: ParkingSpot?
        
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
        
        let minStartTimeDate = response.minStartTime
        let minEndTimeDate = self.calendar.date(byAdding: .minute, value: 30, to: response.minStartTime) ?? Date()
        let maxStartTimeDate = self.calendar.date(bySettingHour: 21, minute: 30, second: 0, of: response.startTime) ?? Date()
        let maxEndTimeDate = self.calendar.date(bySettingHour: 22, minute: 0, second: 0, of: response.endTime) ?? Date()
        let minDate = Date()
        let maxDate = self.calendar.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        let curDate = response.startTime
        var curStartTimeDate = response.startTime
        let curEndTimeDate = response.endTime
        
        if curStartTimeDate < minStartTimeDate {
            curStartTimeDate = minStartTimeDate
        }
        
        view?.displayParkingMap(MapModel.ParkingMap.ViewModel(notAvailableParkingSpots: notAvailableParkingSpots, notFreeParkingSpots: notFreeParkingSpots, freeParkingSpots: freeParkingSpotsForTime, reservedParkingSpot: reservedParkingSpot, parkingLevelCanvas: response.parkingLevelCanvas, buildingForDisplay: response.building, levelForDisplay: response.levelForDisplay, parkingLevels: response.parkingLevels, minStartTimeDate: minStartTimeDate, minEndTimeDate: minEndTimeDate, maxStartTimeDate: maxStartTimeDate, maxEndTimeDate: maxEndTimeDate, minDate: minDate, maxDate: maxDate, curDate: curDate, curStartTimeDate: curStartTimeDate, curEndTimeDate: curEndTimeDate))
    }
    
    func presentPreviousScene(_ response: Model.PreviousScene.Response) {
        view?.displayPreviousScene(MapModel.PreviousScene.ViewModel())
    }
    
    func presentReloadedMap(_ response: Model.ReloadMap.Response) {
        var notAvailableParkingSpots: [ParkingSpot]? = []
        var notFreeParkingSpots: [ParkingSpot]? = []
        var freeParkingSpotsForTime: [ParkingSpot]? = []
        var reservedParkingSpot: ParkingSpot?
        
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
        
        view?.displayReloadedMap(MapModel.ReloadMap.ViewModel(notAvailableParkingSpots: notAvailableParkingSpots, notFreeParkingSpots: notFreeParkingSpots, freeParkingSpots: freeParkingSpotsForTime, reservedParkingSpot: reservedParkingSpot, parkingLevelCanvas: response.parkingLevelCanvas, minStartTimeDate: response.minStartTime, minEndTimeDate: response.minEndTime, curEndTimeDate: response.curEndTime))
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
