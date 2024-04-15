//
//  MapInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MapInteractor {
    // MARK: - Private Properties
    private let presenter: MapPresentationLogic
    private let worker: MapWorkerLogic
    private var buildingID: String?
    private var reservationID: String?
    private var startTime: String?
    private var endTime: String?
    private var calendar = Calendar.current
    private var parkingLevels: [ParkingLevel]?
    private var building: Building?
    private var reservations: [Reservation]?
    private var freeParkingSpotsForTime: [ParkingSpot]?
    private var reservedParkingSpot: ParkingSpot?
    private var levelForDisplay: ParkingLevel?
    private var minimumStartTime: String?
    
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Initializers
    init(presenter: MapPresentationLogic, worker: MapWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension MapInteractor: MapBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadParkingMap(_ request: Model.ParkingMap.Request) {
        self.buildingID = nil
        self.reservationID = nil
        self.startTime = nil
        self.endTime = nil
        self.parkingLevels = nil
        self.building = nil
        self.reservations = nil
        self.freeParkingSpotsForTime = nil
        self.reservedParkingSpot = nil
        self.levelForDisplay = nil
        self.minimumStartTime = nil
        
        if let buildingID = request.initBuildingID {
            self.buildingID = buildingID
            
            /// Set the correct time
            let curTimeHour = self.calendar.component(.hour, from: Date())
            let curTimeMinute = self.calendar.component(.minute, from: Date())
            
            if curTimeHour == 21 && curTimeMinute >= 30 || curTimeHour >= 22 {
                let nextDay = self.calendar.date(byAdding: .day, value: 1, to: Date())
                let curDayInt = self.calendar.component(.day, from: nextDay ?? Date())
                var curDay = "\(self.calendar.component(.day, from: nextDay ?? Date()))"
                let curMonthInt = self.calendar.component(.month, from: nextDay ?? Date())
                var curMonth = "\(self.calendar.component(.month, from: nextDay ?? Date()))"
                let curYear = "\(self.calendar.component(.year, from: nextDay ?? Date()))"
                if curMonthInt <= 9 {
                    curMonth = "0\(curMonth)"
                }
                if curDayInt <= 9 {
                    curDay = "0\(curDay)"
                }
                
                self.startTime = "\(curYear)-\(curMonth)-\(curDay)T08:00:00"
                self.endTime = "\(curYear)-\(curMonth)-\(curDay)T22:00:00"
            } else {
                let curDayInt = self.calendar.component(.day, from: Date())
                var curDay = "\(self.calendar.component(.day, from: Date()))"
                let curMonthInt = self.calendar.component(.month, from: Date())
                var curMonth = "\(self.calendar.component(.month, from: Date()))"
                let curYear = "\(self.calendar.component(.year, from: Date()))"
                if curMonthInt <= 9 {
                    curMonth = "0\(curMonth)"
                }
                if curDayInt <= 9 {
                    curDay = "0\(curDay)"
                }
                
                if curTimeMinute > 30 {
                    if curTimeHour < 9 {
                        self.startTime = "\(curYear)-\(curMonth)-\(curDay)T0\(curTimeHour + 1):00:00"
                    } else {
                        self.startTime = "\(curYear)-\(curMonth)-\(curDay)T\(curTimeHour + 1):00:00"
                    }
                    self.endTime = "\(curYear)-\(curMonth)-\(curDay)T22:00:00"
                } else {
                    if curTimeHour <= 9 {
                        self.startTime = "\(curYear)-\(curMonth)-\(curDay)T0\(curTimeHour):30:00"
                    } else {
                        self.startTime = "\(curYear)-\(curMonth)-\(curDay)T\(curTimeHour):30:00"
                    }
                    self.endTime = "\(curYear)-\(curMonth)-\(curDay)T22:00:00"
                }
            }
            
            if let startTime = self.startTime {
                self.minimumStartTime = "\(startTime.suffix(8).prefix(5))"
            }
            
            if let buildingID = self.buildingID {
                self.dispatchGroup.enter()
                self.worker.getBuilding(buildingID: buildingID) { [weak self] buildingData, error in
                    if let error = error {
                        print(error)
                        /// failure to get data for that building
                    } else if let building = buildingData {
                        self?.building = building
                    }
                    self?.dispatchGroup.leave()
                }
                
                self.dispatchGroup.enter()
                self.worker.getAllBuildingLevels(buildingID: buildingID) { [weak self] levelsData, error in
                    if let error = error {
                        print(error)
                        /// failure to get data for that building
                    } else if let parkingLevels = levelsData, !parkingLevels.isEmpty {
                        self?.parkingLevels = parkingLevels
                        self?.levelForDisplay = parkingLevels[0]
                        
                        if let startTime = self?.startTime, let endTime = self?.endTime {
                            self?.dispatchGroup.enter()
                            self?.worker.getAllLevelFreeSpots(parkingLevelID: parkingLevels[0].id, startTime: startTime, endTime: endTime, completion: { [weak self] parkingSpotsData, error in
                                if let error = error {
                                    print(error)
                                    /// failure to get data for that building/level
                                } else if let parkingSpots = parkingSpotsData {
                                    self?.freeParkingSpotsForTime = parkingSpots
                                }
                                self?.dispatchGroup.leave()
                            })
                        }
                    }
                    self?.dispatchGroup.leave()
                }
                
                self.dispatchGroup.enter()
                self.worker.getAllReservations(completion: { [weak self] reservationsData, error in
                    if let error = error {
                        print(error)
                        /// failure to get data for that building/level
                    } else if let reservations = reservationsData, !reservations.isEmpty {
                        self?.reservations = []
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        for reservation in reservations {
                            if let startTime = self?.startTime, let endTime = self?.endTime, let dateStartTime = dateFormatter.date(from: startTime), let dateEndTime = dateFormatter.date(from: endTime), let dateReserveStartTime = dateFormatter.date(from: reservation.startTime), let dateReserveEndTime = dateFormatter.date(from: reservation.endTime), dateReserveEndTime > Date() {
                                if dateStartTime >= dateReserveStartTime && dateStartTime <= dateReserveEndTime || dateEndTime >= dateReserveStartTime && dateEndTime <= dateReserveEndTime || dateStartTime <= dateReserveStartTime && dateEndTime >= dateReserveEndTime || dateStartTime >= dateReserveStartTime && dateEndTime <= dateReserveEndTime {
                                    self?.reservations?.append(reservation)
                                }
                            }
                        }
                        if let reservations = self?.reservations {
                            if reservations.isEmpty {
                                self?.reservations = nil
                            }
                        }
                    }
                    self?.dispatchGroup.leave()
                })
                
                self.dispatchGroup.wait()
                if let parkingLevels = self.parkingLevels, let startTime = self.startTime, let endTime = self.endTime, let building = self.building, let levelForDisplay = self.levelForDisplay, let minimumStartTime = self.minimumStartTime, let freeParkingSpotsForTime = self.freeParkingSpotsForTime {
                    self.presenter.presentParkingMap(MapModel.ParkingMap.Response(freeParkingSpotsForTime: freeParkingSpotsForTime, reservations: self.reservations, parkingLevelCanvas: levelForDisplay.canvas, parkingLevels: parkingLevels, startTime: startTime, endTime: endTime, building: building, levelForDisplay: levelForDisplay, minimumStartTime: minimumStartTime))
                } else {
                    self.presenter.presentLoadingFailure(MapModel.LoadingFailure.Response())
                }
            }
        } else if let reservationID = request.initReservationID {
            self.reservationID = reservationID
            
            let curTimeHour = self.calendar.component(.hour, from: Date())
            let curTimeMinute = self.calendar.component(.minute, from: Date())
            
            if curTimeMinute > 30 {
                if curTimeHour < 9 {
                    self.minimumStartTime = "0\(curTimeHour + 1):00"
                } else {
                    self.minimumStartTime = "\(curTimeHour + 1):00"
                }
            } else {
                if curTimeHour <= 9 {
                    self.minimumStartTime = "0\(curTimeHour):30"
                } else {
                    self.minimumStartTime = "\(curTimeHour):30"
                }
            }
            
            if let _ = self.reservationID {
                self.dispatchGroup.enter()
                self.worker.getAllReservations(completion: { [weak self] reservationsData, error in
                    if let error = error {
                        print(error)
                    } else if let reservations = reservationsData {
                        for reserve in reservations {
                            if let reservationID = self?.reservationID {
                                if reserve.id == reservationID {
                                    self?.reservations = [reserve]
                                    self?.startTime = reserve.startTime
                                    self?.endTime = reserve.endTime
                                }
                            }
                        }
                        
                        guard let reservation = self?.reservations?[0] else { return }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        if let dateReserveEndTime = dateFormatter.date(from: reservation.endTime) {
                            if dateReserveEndTime < Date() {
                                /// failure, reservation was finished
                                return
                            }
                        }
                        
                        self?.dispatchGroup.enter()
                        self?.worker.getParkingSpot(parkingSpotID: reservation.parkingSpotId, completion: { [weak self] parkingSpotData, error in
                            if let error = error {
                                print(error)
                            } else if let parkingSpot = parkingSpotData {
                                self?.reservedParkingSpot = parkingSpot
                                
                                self?.dispatchGroup.enter()
                                self?.worker.getBuilding(buildingID: parkingSpot.buildingId) { [weak self] buildingData, error in
                                    if let error = error {
                                        print(error)
                                        /// failure to get data for that building
                                    } else if let building = buildingData {
                                        self?.building = building
                                        
                                        self?.dispatchGroup.enter()
                                        self?.worker.getAllBuildingLevels(buildingID: building.id) { [weak self] levelsData, error in
                                            if let error = error {
                                                print(error)
                                                /// failure to get data for that building/level
                                            } else if let parkingLevels = levelsData, !parkingLevels.isEmpty {
                                                self?.parkingLevels = parkingLevels
                                            }
                                            self?.dispatchGroup.leave()
                                        }
                                    }
                                    self?.dispatchGroup.leave()
                                }
                                
                                self?.dispatchGroup.enter()
                                self?.worker.getParkingLevel(parkingLevelID: parkingSpot.levelId, completion: { [weak self] parkingLevelData, error in
                                    if let error = error {
                                        print(error)
                                    } else if let parkingLevel = parkingLevelData {
                                        self?.levelForDisplay = parkingLevel
                                        
                                        if let startTime = self?.startTime, let endTime = self?.endTime {
                                            self?.dispatchGroup.enter()
                                            self?.worker.getAllLevelFreeSpots(parkingLevelID: parkingLevel.id, startTime: startTime, endTime: endTime, completion: { [weak self] parkingSpotsData, error in
                                                if let error = error {
                                                    print(error)
                                                    /// failure to get data for that building/level
                                                } else if let parkingSpots = parkingSpotsData {
                                                    self?.freeParkingSpotsForTime = parkingSpots
                                                }
                                                self?.dispatchGroup.leave()
                                            })
                                        }
                                    }
                                    self?.dispatchGroup.leave()
                                })
                            }
                            self?.dispatchGroup.leave()
                        })
                    }
                    self?.dispatchGroup.leave()
                })
                
                self.dispatchGroup.wait()
                if let reservations = self.reservations, let parkingLevels = self.parkingLevels, let startTime = self.startTime, let endTime = self.endTime, let building = self.building, let levelForDisplay = self.levelForDisplay, let minimumStartTime = self.minimumStartTime, let freeParkingSpotsForTime = self.freeParkingSpotsForTime {
                    self.presenter.presentParkingMap(MapModel.ParkingMap.Response(freeParkingSpotsForTime: freeParkingSpotsForTime, reservations: reservations, parkingLevelCanvas: levelForDisplay.canvas, parkingLevels: parkingLevels, startTime: startTime, endTime: endTime, building: building, levelForDisplay: levelForDisplay, minimumStartTime: minimumStartTime))
                } else {
                    self.presenter.presentLoadingFailure(MapModel.LoadingFailure.Response())
                }
            }
        }
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(MapModel.Home.Response())
    }
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(MapModel.More.Response())
    }
    
    func loadPreviousScene(_ request: Model.PreviousScene.Request) {
        presenter.presentPreviousScene(MapModel.PreviousScene.Response())
    }
    
    func loadReloadedMap(_ request: Model.ReloadMap.Request) {
        self.buildingID = nil
        self.reservationID = nil
        self.startTime = nil
        self.endTime = nil
        self.parkingLevels = nil
        self.building = nil
        self.reservations = nil
        self.freeParkingSpotsForTime = nil
        self.reservedParkingSpot = nil
        self.levelForDisplay = nil
        self.minimumStartTime = nil
        
        self.startTime = "\(request.date)T\(request.startTime):00"
        self.endTime = "\(request.date)T\(request.endTime):00"
        
        if request.date == "\(Date())".prefix(10) {
            let curTimeHour = self.calendar.component(.hour, from: Date())
            let curTimeMinute = self.calendar.component(.minute, from: Date())
            
            if curTimeMinute > 30 {
                if curTimeHour < 9 {
                    self.minimumStartTime = "0\(curTimeHour + 1):00"
                } else {
                    self.minimumStartTime = "\(curTimeHour + 1):00"
                }
            } else {
                if curTimeHour <= 9 {
                    self.minimumStartTime = "0\(curTimeHour):30"
                } else {
                    self.minimumStartTime = "\(curTimeHour):30"
                }
            }
        } else {
            self.minimumStartTime = "08:00"
        }
        
        var updatedCurEndTime: String?
        
        if let startHour = Int(request.startTime.prefix(2)), let startMinute = Int(request.startTime.suffix(2)), let endHour = Int(request.endTime.prefix(2)), let endMinute = Int(request.endTime.suffix(2)) {
            if startHour == endHour && startMinute > endMinute || startHour > endHour {
                if startMinute == 30 {
                    if startHour < 9 {
                        updatedCurEndTime = "0\(startHour):00"
                    } else {
                        updatedCurEndTime = "\(startHour + 1):00"
                    }
                } else {
                    if startHour <= 9 {
                        updatedCurEndTime = "0\(startHour):30"
                    } else {
                        updatedCurEndTime = "\(startHour):30"
                    }
                }
                if let updatedCurEndTime = updatedCurEndTime {
                    self.endTime = "\(request.date)T\(updatedCurEndTime):00"
                }
            }
        }
        
        self.dispatchGroup.enter()
        self.worker.getParkingLevel(parkingLevelID: request.floorID) { [weak self] parkingLevelData, error in
            if let error = error {
                print(error)
                /// failure to get data for that level
            } else if let parkingLevel = parkingLevelData {
                self?.levelForDisplay = parkingLevel
                
                if let startTime = self?.startTime, let endTime = self?.endTime {
                    self?.dispatchGroup.enter()
                    self?.worker.getAllLevelFreeSpots(parkingLevelID: parkingLevel.id, startTime: startTime, endTime: endTime, completion: { [weak self] parkingSpotsData, error in
                        if let error = error {
                            print(error)
                            /// failure to get data for that building/level
                        } else if let parkingSpots = parkingSpotsData, !parkingSpots.isEmpty {
                            self?.freeParkingSpotsForTime = parkingSpots
                        }
                        self?.dispatchGroup.leave()
                    })
                }
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        self.worker.getAllReservations(completion: { [weak self] reservationsData, error in
            if let error = error {
                print(error)
                /// failure to get data for that building/level
            } else if let reservations = reservationsData, !reservations.isEmpty {
                self?.reservations = reservations
                self?.reservations = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                for reservation in reservations {
                    if let startTime = self?.startTime, let endTime = self?.endTime, let dateStartTime = dateFormatter.date(from: startTime), let dateEndTime = dateFormatter.date(from: endTime), let dateReserveStartTime = dateFormatter.date(from: reservation.startTime), let dateReserveEndTime = dateFormatter.date(from: reservation.endTime), dateReserveEndTime > Date() {
                        if dateStartTime >= dateReserveStartTime && dateStartTime <= dateReserveEndTime || dateEndTime >= dateReserveStartTime && dateEndTime <= dateReserveEndTime || dateStartTime <= dateReserveStartTime && dateEndTime >= dateReserveEndTime || dateStartTime >= dateReserveStartTime && dateEndTime <= dateReserveEndTime {
                            self?.reservations?.append(reservation)
                        }
                    }
                }
                if let reservations = self?.reservations {
                    if reservations.isEmpty {
                        self?.reservations = nil
                    }
                }
            }
            self?.dispatchGroup.leave()
        })
        
        self.dispatchGroup.wait()
        if let freeParkingSpotsForTime = self.freeParkingSpotsForTime, let levelForDisplay = self.levelForDisplay, let minimumStartTime = self.minimumStartTime {
            self.presenter.presentReloadedMap(MapModel.ReloadMap.Response(freeParkingSpotsForTime: freeParkingSpotsForTime, reservations: self.reservations, parkingLevelCanvas: levelForDisplay.canvas, minimumStartTime: minimumStartTime, updatedCurEndTime: updatedCurEndTime, curStartTime: request.startTime))
        } else {
            self.presenter.presentReloadingFailure(MapModel.ReloadingFailure.Response())
        }
    }
    
    func loadReservationCard(_ request: Model.ReservationCard.Request) {
        self.presenter.presentReservationCard(MapModel.ReservationCard.Response(parkingSpotID: request.parkingSpotID, date: request.date, startTime: request.startTime, endTime: request.endTime, onUpdateAction: request.onUpdateAction, spotState: request.spotState))
    }
}
