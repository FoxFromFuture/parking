//
//  ReservationCardInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/5/24.
//

import UIKit

final class ReservationCardInteractor {
    // MARK: - Private Properties
    private let presenter: ReservationCardPresentationLogic
    private let networkManager = NetworkManager()
    private var spotState: ReservationCardSpotState?
    private var curParkingSpot: ParkingSpot?
    private var allParkingSpots: [ParkingSpot]?
    private var allReservations: [Reservation]?
    private var cars: [Car]?
    private var actualReservations: [Reservation]?
    private var reservationID: String?
    private var reservationCar: Car?
    private var reservationStartTime: String?
    private var reservationEndTime: String?
    private var reservationsLimitForTime: Bool = false
    private var reservationsLimit: Bool = false
    private var weekendLimit: Bool = false
    private var startTime: Date?
    private var endTime: Date?
    private var wasDeleted: Bool = false
    private let dispatchGroup = DispatchGroup()
    private var calendar = Calendar(identifier: .gregorian)
    
    // MARK: - Initializers
    init(presenter: ReservationCardPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension ReservationCardInteractor: ReservationCardBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadReservationCardInfo(_ request: Model.ReservationCardInfo.Request) {
        // clear old data
        curParkingSpot = nil
        allParkingSpots = nil
        allReservations = nil
        cars = nil
        reservationCar = nil
        actualReservations = nil
        reservationID = nil
        reservationStartTime = nil
        reservationEndTime = nil
        startTime = nil
        endTime = nil
        
        self.spotState = request.spotState
        
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
        
        if let startTime = self.startTime, let weekday = self.calendar.dateComponents([.weekday], from: startTime).weekday {
            if weekday == 1 || weekday == 7 {
                self.weekendLimit = true
            }
        }
        
        self.dispatchGroup.enter()
        self.networkManager.getParkingSpot(parkingSpotID: request.parkingSpotID) { [weak self] parkingSpotData, error in
            if let error = error {
                print(error)
            } else if let parkingSpot = parkingSpotData {
                self?.curParkingSpot = parkingSpot
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        self.networkManager.getAllParkingSpots { [weak self] parkingSpotsData, error in
            if let error = error {
                print(error)
            } else if let parkingSpots = parkingSpotsData {
                self?.allParkingSpots = parkingSpots
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        self.networkManager.getAllReservations { [weak self] reservationsData, error in
            if let error = error {
                print(error)
            } else if let reservations = reservationsData {
                self?.allReservations = reservations
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        self.networkManager.getAllCars { [weak self] carsData, error in
            if let error = error {
                print(error)
                /// failure
            } else if let cars = carsData, !cars.isEmpty {
                self?.cars = cars
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.wait()
        
        if let reservations = self.allReservations, let allParkingSpots = self.allParkingSpots, let curParkingSpot = self.curParkingSpot {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            var actualBuildingReservations: [Reservation] = []
            
            for reservation in reservations {
                for spot in allParkingSpots {
                    if reservation.parkingSpotId == spot.id && spot.buildingId == curParkingSpot.buildingId, let cars = self.cars, let reservationEndTime = dateFormatter.date(from: reservation.endTime), reservationEndTime > Date() {
                        actualBuildingReservations.append(reservation)
                        
                        if self.reservationsLimitForTime == false, let startTime = self.startTime, let endTime = self.endTime, let dateReserveStartTime = dateFormatter.date(from: reservation.startTime), let dateReserveEndTime = dateFormatter.date(from: reservation.endTime) {
                            if startTime >= dateReserveStartTime && startTime <= dateReserveEndTime || endTime >= dateReserveStartTime && endTime <= dateReserveEndTime || startTime <= dateReserveStartTime && endTime >= dateReserveEndTime || startTime >= dateReserveStartTime && endTime <= dateReserveEndTime {
                                self.reservationsLimitForTime = true
                                self.reservationID = reservation.id
                                self.reservationStartTime = "\(reservation.startTime)"
                                self.reservationEndTime = "\(reservation.endTime)"
                                for car in cars {
                                    if car.id == reservation.carId {
                                        self.reservationCar = car
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if actualBuildingReservations.count == 5 {
                self.reservationsLimit = true
            }
        }
        
        if let parkingSpot = self.curParkingSpot, let cars = self.cars, let startTime = self.startTime, let endTime = self.endTime {
            self.presenter.presentReservationCardInfo(Model.ReservationCardInfo.Response(parkingSpot: parkingSpot, cars: cars, reservationCar: self.reservationCar, reservationID: self.reservationID, reservationStartTime: self.reservationStartTime, reservationEndTime: self.reservationEndTime, reservationsLimitForTime: self.reservationsLimitForTime, reservationsLimit: self.reservationsLimit, weekendLimit: self.weekendLimit, startTime: startTime, endTime: endTime))
        } else {
            self.presenter.presentLoadingFailure(ReservationCardModel.LoadingFailure.Response())
        }
    }
    
    func loadCreateReservation(_ request: Model.CreateReservation.Request) {
        self.reservationID = nil
        self.reservationCar = nil
        
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
        
        let startDate = self.calendar.date(from: startTimeComponentsForBuild)
        let endDate = self.calendar.date(from: endTimeComponentsForBuild)
        
        if let startDate = startDate, let endDate = endDate {
            self.dispatchGroup.enter()
            self.networkManager.addNewReservation(carId: request.carID, employeeId: request.employeeID, parkingSpotId: request.parkingSpotID, startTime: startDate.getISO8601Str(), endTime: endDate.getISO8601Str()) { [weak self] reservationData, error in
                if let error = error {
                    print(error)
                    /// failure
                } else if let reservation = reservationData {
                    self?.reservationID = reservation.id
                }
                self?.dispatchGroup.leave()
            }
            
            self.dispatchGroup.enter()
            self.networkManager.getCar(carID: request.carID) { [weak self] carData, error in
                if let error = error {
                    print(error)
                    /// failure
                } else if let car = carData {
                    self?.reservationCar = car
                }
                self?.dispatchGroup.leave()
            }
        }
        
        self.dispatchGroup.wait()
        if let reservationID = self.reservationID, let car = reservationCar {
            self.presenter.presentCreateReservation(ReservationCardModel.CreateReservation.Response(reservationID: reservationID, car: car))
        } else {
            self.presenter.presentLoadingFailure(ReservationCardModel.LoadingFailure.Response())
        }
    }
    
    func loadCancelReservation(_ request: Model.CancelReservation.Request) {
        self.cars = nil
        self.wasDeleted = false
        
        self.dispatchGroup.enter()
        self.networkManager.deleteReservation(id: request.reservationID) { [weak self] error in
            if let error = error {
                print(error)
                /// failure
            } else {
                self?.wasDeleted = true
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        self.networkManager.getAllCars { [weak self] carsData, error in
            if let error = error {
                print(error)
                /// failure
            } else if let cars = carsData, !cars.isEmpty {
                self?.cars = cars
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.wait()
        if self.wasDeleted, let cars = self.cars {
            self.presenter.presentCancelReservation(ReservationCardModel.CancelReservation.Response(cars: cars))
        } else {
            self.presenter.presentLoadingFailure(ReservationCardModel.LoadingFailure.Response())
        }
    }
}
