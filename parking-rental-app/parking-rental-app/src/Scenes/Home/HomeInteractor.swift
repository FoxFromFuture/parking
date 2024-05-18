//
//  HomeInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit
import Logging

final class HomeInteractor {
    // MARK: - Private Properties
    private let presenter: HomePresentationLogic
    private let networkManager = NetworkManager()
    private var reservations: [Reservation]?
    private var parkingSpots: [ParkingSpot]?
    private var parkingLevels: [ParkingLevel]?
    private var buildings: [Building]?
    private let logger = Logger(label: "com.foxfromfuture.parking-rental-app.home")
    
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Initializers
    init(presenter: HomePresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension HomeInteractor: HomeBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadReservations(_ request: Model.GetReservations.Request) {
        /// Clear old data
        self.reservations = nil
        self.parkingSpots = nil
        self.parkingLevels = nil
        self.buildings = nil
        
        self.dispatchGroup.enter()
        /// Fetch user's reservations data
        self.networkManager.getAllReservations { [weak self] reservationsData, error in
            if let error = error {
                self?.logger.error("Get all reservations error: \(error.rawValue)")
            } else if let reservations = reservationsData, !reservations.isEmpty {
                /// Save fetched reservations
                let timeDateFormatter = DateFormatter()
                timeDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                self?.reservations = []
                for reservation in reservations {
                    if let reservationEndTime = timeDateFormatter.date(from: reservation.endTime), reservationEndTime > Date() {
                        self?.reservations?.append(reservation)
                    }
                }
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        /// Fetch all parking spots data
        self.networkManager.getAllParkingSpots { [weak self] parkingSpotsData, error in
            if let error = error {
                self?.logger.error("Get all parking spots error: \(error.rawValue)")
            } else if let parkingSpots = parkingSpotsData {
                /// Save fetched parking spots
                self?.parkingSpots = parkingSpots
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        /// Fetch all parking levels data
        networkManager.getAllParkingLevels { [weak self] parkingLevelsData, error in
            if let error = error {
                self?.logger.error("Get all parking levels error: \(error.rawValue)")
            } else if let parkingLevels = parkingLevelsData {
                /// Save fetched parking levels
                self?.parkingLevels = parkingLevels
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.enter()
        /// Fetch all buildings data
        networkManager.getAllBuildings { [weak self] buildingsData, error in
            if let error = error {
                self?.logger.error("Get all buildings error: \(error.rawValue)")
            } else if let buildings = buildingsData {
                /// Save fetched buildings
                self?.buildings = buildings
            }
            self?.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) { [weak self] in
            /// Present reservations if all data was retrieved from server
            if let reservations = self?.reservations {
                if let parkingSpots = self?.parkingSpots, let parkingLevels = self?.parkingLevels, let buildings = self?.buildings {
                    self?.presenter.presentReservations(Model.GetReservations.Response(reservations: reservations, parkingSpots: parkingSpots, parkingLevels: parkingLevels, buildings: buildings))
                } else {
                    self?.presenter.presentLoadingFailure(HomeModel.LoadingFailure.Response())
                }
            } else {
                if let _ = self?.parkingSpots, let _ = self?.parkingLevels, let _ = self?.buildings {
                    self?.presenter.presentNoData(HomeModel.NoData.Response())
                } else {
                    self?.presenter.presentLoadingFailure(HomeModel.LoadingFailure.Response())
                }
            }
        }
    }
    
    func loadBuildings(_ request: Model.Buildings.Request) {
        self.presenter.presentBuildings(Model.Buildings.Response())
    }
    
    func loadMap(_ request: Model.Map.Request) {
        self.presenter.presentMap(Model.Map.Response(reservationID: request.reservationID))
    }
    
    func loadProfile(_ request: Model.Profile.Request) {
        self.presenter.presentProfile(Model.Profile.Response())
    }
}
