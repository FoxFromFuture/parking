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
    private var startTime: Date?
    private var endTime: Date?
    private var calendar = Calendar(identifier: .gregorian)
    private var parkingLevels: [ParkingLevel]?
    private var building: Building?
    private var reservations: [Reservation]?
    private var freeParkingSpotsForTime: [ParkingSpot]?
    private var reservedParkingSpot: ParkingSpot?
    private var levelForDisplay: ParkingLevel?
    private var minStartTime: Date?
    private var minEndTime: Date?
    
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
        self.minStartTime = nil
        
        if let buildingID = request.initBuildingID {
            self.buildingID = buildingID
            
            /// Set the correct time
            let curTimeHour = self.calendar.component(.hour, from: Date())
            
            if let bounds = self.calendar.date(bySettingHour: 21, minute: 30, second: 0, of: Date()), Date() > bounds {
                if let nextDay = self.calendar.date(byAdding: .day, value: 1, to: Date()) {
                    self.startTime = self.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: nextDay)
                    self.endTime = self.calendar.date(bySettingHour: 22, minute: 0, second: 0, of: nextDay)
                }
            } else {
                if let bounds = self.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()), Date() < bounds {
                    self.startTime = self.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
                } else if let bounds = self.calendar.date(bySettingHour: curTimeHour, minute: 30, second: 0, of: Date()), Date() > bounds {
                    self.startTime = self.calendar.date(bySettingHour: curTimeHour + 1, minute: 0, second: 0, of: Date())
                } else {
                    self.startTime = self.calendar.date(bySettingHour: curTimeHour, minute: 30, second: 0, of: Date())
                }
                self.endTime = self.calendar.date(bySettingHour: 22, minute: 0, second: 0, of: Date())
            }
            
            self.minStartTime = startTime
            
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
                            self?.worker.getAllLevelFreeSpots(parkingLevelID: parkingLevels[0].id, startTime: startTime.getISO8601Str(), endTime: endTime.getISO8601Str(), completion: { [weak self] parkingSpotsData, error in
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
                            if let startTime = self?.startTime, let endTime = self?.endTime, let dateReserveStartTime = dateFormatter.date(from: reservation.startTime), let dateReserveEndTime = dateFormatter.date(from: reservation.endTime), dateReserveEndTime > Date() {
                                if startTime >= dateReserveStartTime && startTime <= dateReserveEndTime || endTime >= dateReserveStartTime && endTime <= dateReserveEndTime || startTime <= dateReserveStartTime && endTime >= dateReserveEndTime || startTime >= dateReserveStartTime && endTime <= dateReserveEndTime {
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
                if let parkingLevels = self.parkingLevels, let startTime = self.startTime, let endTime = self.endTime, let building = self.building, let levelForDisplay = self.levelForDisplay, let minStartTime = self.minStartTime, let freeParkingSpotsForTime = self.freeParkingSpotsForTime {
                    self.presenter.presentParkingMap(MapModel.ParkingMap.Response(freeParkingSpotsForTime: freeParkingSpotsForTime, reservations: self.reservations, parkingLevelCanvas: levelForDisplay.canvas, parkingLevels: parkingLevels, startTime: startTime, endTime: endTime, building: building, levelForDisplay: levelForDisplay, minStartTime: minStartTime))
                } else {
                    self.presenter.presentLoadingFailure(MapModel.LoadingFailure.Response())
                }
            }
        } else if let reservationID = request.initReservationID {
            self.reservationID = reservationID
            
            let curTimeHour = self.calendar.component(.hour, from: Date())
            
            if let bounds = self.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()), Date() < bounds {
                self.minStartTime = self.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
            } else if let bounds = self.calendar.date(bySettingHour: curTimeHour, minute: 30, second: 0, of: Date()), Date() > bounds {
                self.minStartTime = self.calendar.date(bySettingHour: curTimeHour + 1, minute: 0, second: 0, of: Date())
            } else {
                self.minStartTime = self.calendar.date(bySettingHour: curTimeHour, minute: 30, second: 0, of: Date())
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
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    
                                    self?.reservations = [reserve]
                                    self?.startTime = dateFormatter.date(from: reserve.startTime)
                                    self?.endTime = dateFormatter.date(from: reserve.endTime)
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
                                            self?.worker.getAllLevelFreeSpots(parkingLevelID: parkingLevel.id, startTime: startTime.getISO8601Str(), endTime: endTime.getISO8601Str(), completion: { [weak self] parkingSpotsData, error in
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
                if let reservations = self.reservations, let parkingLevels = self.parkingLevels, let startTime = self.startTime, let endTime = self.endTime, let building = self.building, let levelForDisplay = self.levelForDisplay, let minStartTime = self.minStartTime, let freeParkingSpotsForTime = self.freeParkingSpotsForTime {
                    self.presenter.presentParkingMap(MapModel.ParkingMap.Response(freeParkingSpotsForTime: freeParkingSpotsForTime, reservations: reservations, parkingLevelCanvas: levelForDisplay.canvas, parkingLevels: parkingLevels, startTime: startTime, endTime: endTime, building: building, levelForDisplay: levelForDisplay, minStartTime: minStartTime))
                } else {
                    self.presenter.presentLoadingFailure(MapModel.LoadingFailure.Response())
                }
            }
        }
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
        self.minStartTime = nil
        
        let dateComponents = self.calendar.dateComponents([.year, .month, .day], from: request.date)
        let startTimeComponents = self.calendar.dateComponents([.hour, .minute, .second], from: request.startTime)
        let endTimeComponents = self.calendar.dateComponents([.hour, .minute, .second], from: request.endTime)
        
        var startTimeComponentsForBuild = DateComponents()
        startTimeComponentsForBuild.year = dateComponents.year
        startTimeComponentsForBuild.month = dateComponents.month
        startTimeComponentsForBuild.day = dateComponents.day
        startTimeComponentsForBuild.hour = startTimeComponents.hour
        startTimeComponentsForBuild.minute = startTimeComponents.minute
        startTimeComponentsForBuild.second = startTimeComponents.second
        
        var endTimeComponentsForBuild = DateComponents()
        endTimeComponentsForBuild.year = dateComponents.year
        endTimeComponentsForBuild.month = dateComponents.month
        endTimeComponentsForBuild.day = dateComponents.day
        endTimeComponentsForBuild.hour = endTimeComponents.hour
        endTimeComponentsForBuild.minute = endTimeComponents.minute
        endTimeComponentsForBuild.second = endTimeComponents.second
        
        self.startTime = self.calendar.date(from: startTimeComponentsForBuild)
        self.endTime = self.calendar.date(from: endTimeComponentsForBuild)
        
        if request.date.extractDate() == Date().extractDate() {
            let curTimeHour = self.calendar.component(.hour, from: Date())
            
            if let bounds = self.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()), Date() < bounds {
                self.minStartTime = self.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
            } else if let bounds = self.calendar.date(bySettingHour: curTimeHour, minute: 30, second: 0, of: Date()), Date() > bounds {
                self.minStartTime = self.calendar.date(bySettingHour: curTimeHour + 1, minute: 0, second: 0, of: Date())
            } else {
                self.minStartTime = self.calendar.date(bySettingHour: curTimeHour, minute: 30, second: 0, of: Date())
            }
        } else {
            self.minStartTime = self.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
        }
        
        self.minEndTime = self.calendar.date(byAdding: .minute, value: 30, to: request.startTime)
        
        var updatedCurEndTime: Date?
        
        if request.startTime > request.endTime {
            updatedCurEndTime = self.minEndTime
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
                    self?.worker.getAllLevelFreeSpots(parkingLevelID: parkingLevel.id, startTime: startTime.getISO8601Str(), endTime: endTime.getISO8601Str(), completion: { [weak self] parkingSpotsData, error in
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
                    if let startTime = self?.startTime, let endTime = self?.endTime, let dateReserveStartTime = dateFormatter.date(from: reservation.startTime), let dateReserveEndTime = dateFormatter.date(from: reservation.endTime), dateReserveEndTime > Date() {
                        if startTime >= dateReserveStartTime && startTime <= dateReserveEndTime || endTime >= dateReserveStartTime && endTime <= dateReserveEndTime || startTime <= dateReserveStartTime && endTime >= dateReserveEndTime || startTime >= dateReserveStartTime && endTime <= dateReserveEndTime {
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
        if let freeParkingSpotsForTime = self.freeParkingSpotsForTime, let levelForDisplay = self.levelForDisplay, let minStartTime = self.minStartTime, let minEndTime = self.minEndTime {
            self.presenter.presentReloadedMap(MapModel.ReloadMap.Response(freeParkingSpotsForTime: freeParkingSpotsForTime, reservations: self.reservations, parkingLevelCanvas: levelForDisplay.canvas, minStartTime: minStartTime, minEndTime: minEndTime, curEndTime: updatedCurEndTime))
        } else {
            self.presenter.presentReloadingFailure(MapModel.ReloadingFailure.Response())
        }
    }
    
    func loadReservationCard(_ request: Model.ReservationCard.Request) {
        self.presenter.presentReservationCard(MapModel.ReservationCard.Response(parkingSpotID: request.parkingSpotID, date: request.date, startTime: request.startTime, endTime: request.endTime, onUpdateAction: request.onUpdateAction, spotState: request.spotState))
    }
}
