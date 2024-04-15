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
    private var date: String?
    private var startTime: String?
    private var endTime: String?
    private let dispatchGroup = DispatchGroup()
    
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
        self.startTime = "\(request.date)T\(request.startTime):00"
        self.endTime = "\(request.date)T\(request.endTime):00"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let startTime = self.startTime, let startTimeDate = dateFormatter.date(from: startTime), let weekday = Calendar.current.dateComponents([.weekday], from: startTimeDate).weekday {
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
                                
                                if let limit = self?.reservationsLimitForTime, limit == false, let startTime = self?.startTime, let endTime = self?.endTime, let dateStartTime = dateFormatter.date(from: startTime), let dateEndTime = dateFormatter.date(from: endTime), let dateReserveStartTime = dateFormatter.date(from: reservation.startTime), let dateReserveEndTime = dateFormatter.date(from: reservation.endTime) {
                                    if dateStartTime >= dateReserveStartTime && dateStartTime <= dateReserveEndTime || dateEndTime >= dateReserveStartTime && dateEndTime <= dateReserveEndTime || dateStartTime <= dateReserveStartTime && dateEndTime >= dateReserveEndTime || dateStartTime >= dateReserveStartTime && dateEndTime <= dateReserveEndTime {
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
                                    self?.reservationStartTime = "\(reservation.startTime.suffix(8).prefix(5))"
                                    self?.reservationEndTime = "\(reservation.endTime.suffix(8).prefix(5))"
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
        if let parkingSpot = self.parkingSpot, let car = self.car {
            self.presenter.presentReservationCardInfo(Model.ReservationCardInfo.Response(parkingSpot: parkingSpot, car: car, reservationID: self.reservationID, reservationStartTime: self.reservationStartTime, reservationEndTime: self.reservationEndTime, reservationsLimitForTime: self.reservationsLimitForTime, reservationsLimit: self.reservationsLimit, weekendLimit: self.weekendLimit))
        } else {
            self.presenter.presentLoadingFailure(ReservationCardModel.LoadingFailure.Response())
        }
    }
    
    func loadCreateReservation(_ request: Model.CreateReservation.Request) {
        let startDate = "\(request.date)T\(request.startTime):00"
        let endDate = "\(request.date)T\(request.endTime):00"
        
        self.worker.addNewReservation(carId: request.carID, employeeId: request.employeeID, parkingSpotId: request.parkingSpotID, startTime: startDate, endTime: endDate) { [weak self] reservationData, error in
            if let error = error {
                print(error)
                /// failure
                self?.presenter.presentLoadingFailure(ReservationCardModel.LoadingFailure.Response())
            } else if let reservation = reservationData {
                self?.presenter.presentCreateReservation(ReservationCardModel.CreateReservation.Response(reservationID: reservation.id))
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
