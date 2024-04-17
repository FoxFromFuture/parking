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
    private let worker: ReservationCardWorkerLogic
    private var spotState: ReservationCardSpotState?
    private var parkingSpot: ParkingSpot?
    private var car: Car?
    private var actualReservations: [Reservation]?
    private var reservationID: String?
    private var reservationStartTime: String?
    private var reservationEndTime: String?
    private var reservationsLimitForTime: Bool = false
    private var reservationsLimit: Bool = false
    private var weekendLimit: Bool = false
    private var startTime: Date?
    private var endTime: Date?
    private let dispatchGroup = DispatchGroup()
    private var calendar = Calendar(identifier: .gregorian)
    
    // MARK: - Initializers
    init(presenter: ReservationCardPresentationLogic, worker: ReservationCardWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension ReservationCardInteractor: ReservationCardBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadReservationCardInfo(_ request: Model.ReservationCardInfo.Request) {
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
        self.worker.getParkingSpot(parkingSpotID: request.parkingSpotID) { [weak self] parkingSpotData, error in
            if let error = error {
                print(error)
                /// failure
            } else if let parkingSpot = parkingSpotData {
                self?.parkingSpot = parkingSpot
                self?.dispatchGroup.enter()
                self?.worker.getAllReservations(completion: { [weak self] reservationsData, error in
                    if let error = error {
                        print(error)
                        /// failure
                    } else if let reservations = reservationsData, !reservations.isEmpty {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        self?.actualReservations = []
                        for reservation in reservations {
                            if let reservationEndTime = dateFormatter.date(from: reservation.endTime), reservationEndTime > Date() {
                                self?.actualReservations?.append(reservation)
                                
                                if let limit = self?.reservationsLimitForTime, limit == false, let startTime = self?.startTime, let endTime = self?.endTime, let dateReserveStartTime = dateFormatter.date(from: reservation.startTime), let dateReserveEndTime = dateFormatter.date(from: reservation.endTime) {
                                    if startTime >= dateReserveStartTime && startTime <= dateReserveEndTime || endTime >= dateReserveStartTime && endTime <= dateReserveEndTime || startTime <= dateReserveStartTime && endTime >= dateReserveEndTime || startTime >= dateReserveStartTime && endTime <= dateReserveEndTime {
                                        self?.reservationsLimitForTime = true
                                    }
                                }
                            }
                        }
                        
                        if let actualReservations = self?.actualReservations, actualReservations.count == 5 {
                            self?.reservationsLimit = true
                        }
                        
                        if let spotState = self?.spotState, spotState == .reservedSpot, let parkingSpot = self?.parkingSpot, let actualReservations = self?.actualReservations {
                            for reservation in actualReservations {
                                if reservation.parkingSpotId == parkingSpot.id {
                                    self?.reservationID = reservation.id
                                    self?.reservationStartTime = "\(reservation.startTime)"
                                    self?.reservationEndTime = "\(reservation.endTime)"
                                    break
                                }
                            }
                        }
                    }
                    self?.dispatchGroup.leave()
                })
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        self.worker.getAllCars(completion: { [weak self] carsData, error in
            if let error = error {
                print(error)
                /// failure
            } else if let cars = carsData, !cars.isEmpty {
                self?.car = cars[0]
            }
            self?.dispatchGroup.leave()
        })
        
        self.dispatchGroup.wait()
        if let parkingSpot = self.parkingSpot, let car = self.car, let startTime = self.startTime, let endTime = self.endTime {
            self.presenter.presentReservationCardInfo(Model.ReservationCardInfo.Response(parkingSpot: parkingSpot, car: car, reservationID: self.reservationID, reservationStartTime: self.reservationStartTime, reservationEndTime: self.reservationEndTime, reservationsLimitForTime: self.reservationsLimitForTime, reservationsLimit: self.reservationsLimit, weekendLimit: self.weekendLimit, startTime: startTime, endTime: endTime))
        } else {
            self.presenter.presentLoadingFailure(ReservationCardModel.LoadingFailure.Response())
        }
    }
    
    func loadCreateReservation(_ request: Model.CreateReservation.Request) {
        
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
            self.worker.addNewReservation(carId: request.carID, employeeId: request.employeeID, parkingSpotId: request.parkingSpotID, startTime: startDate.getISO8601Str(), endTime: endDate.getISO8601Str()) { [weak self] reservationData, error in
                if let error = error {
                    print(error)
                    /// failure
                    self?.presenter.presentLoadingFailure(ReservationCardModel.LoadingFailure.Response())
                } else if let reservation = reservationData {
                    self?.presenter.presentCreateReservation(ReservationCardModel.CreateReservation.Response(reservationID: reservation.id))
                }
            }
        }
    }
    
    func loadCancelReservation(_ request: Model.CancelReservation.Request) {
        self.worker.deleteReservation(id: request.reservationID) { [weak self] error in
            if let error = error {
                print(error)
                /// failure
                self?.presenter.presentLoadingFailure(ReservationCardModel.LoadingFailure.Response())
            } else {
                self?.presenter.presentCancelReservation(ReservationCardModel.CancelReservation.Response())
            }
        }
    }
}
