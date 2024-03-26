//
//  HomeInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class HomeInteractor {
    // MARK: - Private Properties
    private let presenter: HomePresentationLogic
    private let worker: HomeWorkerLogic
    private var reservations: [Reservation]?
    private var parkingSpots: [ParkingSpot]?
    private var parkingLevels: [ParkingLevel]?
    private var buildings: [Building]?
    
    /// Create group for multiple async tasks
    private let group = DispatchGroup()
    
    // MARK: - Initializers
    init(presenter: HomePresentationLogic, worker: HomeWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
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
        
        /// Fetch user's reservations data
        self.worker.getAllReservations() { [weak self] reservationsData, error in
            if let error = error {
                print(error)
                self?.presenter.presentLoadingFailure(HomeModel.LoadingFailure.Response())
            } else if let reservations = reservationsData {
                /// Save fetched reservations
                self?.reservations = reservations
                
                /// Check if there were any reservations
                if reservations.isEmpty {
                    self?.presenter.presentNoData(HomeModel.NoData.Response())
                    return
                }
                
                /// Fetch all parking spots data
                self?.group.enter()
                self?.worker.getAllParkingSpots(completion: { [weak self] parkingSpotsData, error in
                    if let error = error {
                        print(error)
                    } else if let parkingSpots = parkingSpotsData {
                        /// Save fetched parking spots
                        self?.parkingSpots = parkingSpots
                    }
                    self?.group.leave()
                })
                
                /// Fetch all parking levels data
                self?.group.enter()
                self?.worker.getAllParkingLevels(completion: { [weak self] parkingLevelsData, error in
                    if let error = error {
                        print(error)
                    } else if let parkingLevels = parkingLevelsData {
                        /// Save fetched parking levels
                        self?.parkingLevels = parkingLevels
                    }
                    self?.group.leave()
                })
                
                /// Fetch all buildings data
                self?.group.enter()
                self?.worker.getAllBuildings(completion: { [weak self] buildingsData, error in
                    if let error = error {
                        print(error)
                    } else if let buildings = buildingsData {
                        /// Save fetched buildings
                        self?.buildings = buildings
                    }
                    self?.group.leave()
                })
                
                /// Wait for all grouped async tasks completion
                self?.group.wait()
                
                /// Present reservations if all data was retrieved from server
                if let parkingSpots = self?.parkingSpots, let parkingLevels = self?.parkingLevels, let buildings = self?.buildings {
                    self?.presenter.presentReservations(Model.GetReservations.Response(reservations: reservations, parkingSpots: parkingSpots, parkingLevels: parkingLevels, buildings: buildings))
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
        ParkingSpotsDataStore.shared.parkingSpotForMapID = request.lotID
        self.presenter.presentMap(Model.Map.Response())
    }
    
    func loadProfile(_ request: Model.Profile.Request) {
        self.presenter.presentProfile(Model.Profile.Response())
    }
    
    func loadMore(_ request: Model.More.Request) {
        self.presenter.presentMore(Model.More.Response())
    }
}
